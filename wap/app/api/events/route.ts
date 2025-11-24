import { NextRequest, NextResponse } from 'next/server';

// In-memory event storage
interface Event {
  id: string;
  type: string;
  timestamp: number;
  description: string;
  data?: Record<string, any>;
}

let events: Event[] = [];
let clients: Set<ReadableStreamDefaultController> = new Set();

// Helper to broadcast event to all connected clients
function broadcastEvent(event: Event) {
  const message = `data: ${JSON.stringify(event)}\n\n`;
  clients.forEach((controller) => {
    try {
      controller.enqueue(new TextEncoder().encode(message));
    } catch (error) {
      // Client disconnected, will be cleaned up
      console.error('Error broadcasting to client:', error);
    }
  });
}

// POST - Receive events from Flutter app
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { type, description, data } = body;

    if (!type || !description) {
      return NextResponse.json(
        { error: 'Missing required fields: type and description' },
        { status: 400 }
      );
    }

    const event: Event = {
      id: `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      type,
      timestamp: Date.now(),
      description,
      data: data || {},
    };

    events.push(event);
    
    // Keep only last 100 events
    if (events.length > 100) {
      events = events.slice(-100);
    }

    // Broadcast to all connected SSE clients
    broadcastEvent(event);

    return NextResponse.json({ success: true, event });
  } catch (error) {
    console.error('Error processing event:', error);
    return NextResponse.json(
      { error: 'Failed to process event' },
      { status: 500 }
    );
  }
}

// GET - Server-Sent Events stream for monitoring dashboard
export async function GET(request: NextRequest) {
  const stream = new ReadableStream({
    start(controller) {
      // Add this client to the set
      clients.add(controller);

      // Send initial connection message
      const connectMessage = `data: ${JSON.stringify({
        type: 'connected',
        message: 'Connected to event stream',
        timestamp: Date.now(),
      })}\n\n`;
      controller.enqueue(new TextEncoder().encode(connectMessage));

      // Send existing events
      events.forEach((event) => {
        const message = `data: ${JSON.stringify(event)}\n\n`;
        controller.enqueue(new TextEncoder().encode(message));
      });

      // Keep connection alive with heartbeat
      const heartbeat = setInterval(() => {
        try {
          controller.enqueue(new TextEncoder().encode(': heartbeat\n\n'));
        } catch (error) {
          clearInterval(heartbeat);
          clients.delete(controller);
        }
      }, 30000); // Every 30 seconds

      // Cleanup on close
      request.signal.addEventListener('abort', () => {
        clearInterval(heartbeat);
        clients.delete(controller);
        try {
          controller.close();
        } catch (error) {
          // Already closed
        }
      });
    },
    cancel() {
      // Client disconnected
    },
  });

  return new NextResponse(stream, {
    headers: {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
    },
  });
}

