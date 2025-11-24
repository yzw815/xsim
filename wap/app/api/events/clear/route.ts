import { NextResponse } from 'next/server';

// This imports the events array from the parent route
// In a real production app, you'd use a shared store or database
// For this demo, we'll use a simple module-level variable approach

let eventsStore: any[] = [];

// POST - Clear all events
export async function POST() {
  try {
    // Clear the events
    eventsStore = [];
    
    return NextResponse.json({ 
      success: true, 
      message: 'Events cleared successfully' 
    });
  } catch (error) {
    console.error('Error clearing events:', error);
    return NextResponse.json(
      { error: 'Failed to clear events' },
      { status: 500 }
    );
  }
}

// GET - Get current event count
export async function GET() {
  return NextResponse.json({ 
    count: eventsStore.length,
    events: eventsStore 
  });
}

