'use client';

import { useEffect, useState, useRef } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Separator } from '@/components/ui/separator';
import { 
  Activity, 
  CheckCircle2, 
  Clock, 
  MessageSquare, 
  Phone, 
  Server, 
  Smartphone, 
  Trash2, 
  Wifi, 
  WifiOff 
} from 'lucide-react';

interface Event {
  id: string;
  type: string;
  timestamp: number;
  description: string;
  data?: Record<string, any>;
}

const getEventIcon = (type: string) => {
  switch (type) {
    case 'app_opened':
    case 'login_clicked':
      return <Smartphone className="h-5 w-5" />;
    case 'phone_entered':
      return <Phone className="h-5 w-5" />;
    case 'otp_requested':
    case 'backend_received':
    case 'verifying':
      return <Server className="h-5 w-5" />;
    case 'sms_sent':
    case 'sms_received':
      return <MessageSquare className="h-5 w-5" />;
    case 'code_entered':
      return <Clock className="h-5 w-5" />;
    case 'success':
      return <CheckCircle2 className="h-5 w-5" />;
    default:
      return <Activity className="h-5 w-5" />;
  }
};

const getEventColor = (type: string) => {
  // App events - blue
  if (['app_opened', 'login_clicked', 'phone_entered', 'code_entered'].includes(type)) {
    return 'bg-blue-500/10 text-blue-700 border-blue-200';
  }
  // Backend events - purple
  if (['otp_requested', 'backend_received', 'sms_sent', 'verifying'].includes(type)) {
    return 'bg-purple-500/10 text-purple-700 border-purple-200';
  }
  // User received - green
  if (['sms_received'].includes(type)) {
    return 'bg-green-500/10 text-green-700 border-green-200';
  }
  // Success - emerald
  if (['success'].includes(type)) {
    return 'bg-emerald-500/10 text-emerald-700 border-emerald-200';
  }
  return 'bg-gray-500/10 text-gray-700 border-gray-200';
};

const formatTime = (timestamp: number) => {
  return new Date(timestamp).toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false,
  });
};

export default function DemoMonitorPage() {
  const [events, setEvents] = useState<Event[]>([]);
  const [isConnected, setIsConnected] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);
  const eventSourceRef = useRef<EventSource | null>(null);

  useEffect(() => {
    // Connect to SSE endpoint
    const connectSSE = () => {
      const eventSource = new EventSource('/api/events');
      eventSourceRef.current = eventSource;

      eventSource.onopen = () => {
        console.log('SSE connection established');
        setIsConnected(true);
      };

      eventSource.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data);
          
          // Handle connection message
          if (data.type === 'connected') {
            console.log(data.message);
            return;
          }

          // Add new event
          setEvents((prev) => {
            // Check if event already exists
            if (prev.some(e => e.id === data.id)) {
              return prev;
            }
            return [...prev, data];
          });
        } catch (error) {
          console.error('Error parsing SSE data:', error);
        }
      };

      eventSource.onerror = (error) => {
        console.error('SSE error:', error);
        setIsConnected(false);
        eventSource.close();
        
        // Attempt to reconnect after 3 seconds
        setTimeout(connectSSE, 3000);
      };
    };

    connectSSE();

    return () => {
      if (eventSourceRef.current) {
        eventSourceRef.current.close();
      }
    };
  }, []);

  // Auto-scroll to bottom when new events arrive
  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [events]);

  const handleClearEvents = async () => {
    try {
      const response = await fetch('/api/events/clear', {
        method: 'POST',
      });
      
      if (response.ok) {
        setEvents([]);
      }
    } catch (error) {
      console.error('Error clearing events:', error);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 p-6">
      <div className="mx-auto max-w-6xl space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-4xl font-bold text-slate-900">
              XSIM Auth Demo Monitor
            </h1>
            <p className="text-slate-600 mt-2">
              Real-time authentication flow monitoring
            </p>
          </div>
          <div className="flex items-center gap-4">
            <Badge 
              variant="outline" 
              className={`px-4 py-2 ${
                isConnected 
                  ? 'bg-green-500/10 text-green-700 border-green-200' 
                  : 'bg-red-500/10 text-red-700 border-red-200'
              }`}
            >
              {isConnected ? (
                <>
                  <Wifi className="mr-2 h-4 w-4" />
                  Connected
                </>
              ) : (
                <>
                  <WifiOff className="mr-2 h-4 w-4" />
                  Disconnected
                </>
              )}
            </Badge>
            <Button 
              onClick={handleClearEvents}
              variant="outline"
              className="gap-2"
            >
              <Trash2 className="h-4 w-4" />
              Clear Events
            </Button>
          </div>
        </div>

        {/* Main Content */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Timeline */}
          <Card className="lg:col-span-2">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Activity className="h-5 w-5" />
                Event Timeline
              </CardTitle>
              <CardDescription>
                Live events from the authentication flow
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ScrollArea className="h-[600px] pr-4" ref={scrollRef}>
                {events.length === 0 ? (
                  <div className="flex flex-col items-center justify-center h-[400px] text-center">
                    <Smartphone className="h-16 w-16 text-slate-300 mb-4" />
                    <p className="text-slate-500 text-lg font-medium">
                      Waiting for events...
                    </p>
                    <p className="text-slate-400 text-sm mt-2">
                      Start using the mobile app to see events here
                    </p>
                  </div>
                ) : (
                  <div className="space-y-4">
                    {events.map((event, index) => (
                      <div key={event.id}>
                        <div className="flex gap-4">
                          <div className="flex flex-col items-center">
                            <div 
                              className={`rounded-full p-2 border ${getEventColor(event.type)}`}
                            >
                              {getEventIcon(event.type)}
                            </div>
                            {index < events.length - 1 && (
                              <div className="w-0.5 h-full bg-slate-200 my-2 min-h-[40px]" />
                            )}
                          </div>
                          <div className="flex-1 pb-4">
                            <div className="flex items-start justify-between gap-4">
                              <div className="flex-1">
                                <p className="font-semibold text-slate-900">
                                  {event.description}
                                </p>
                                {event.data && Object.keys(event.data).length > 0 && (
                                  <div className="mt-2 text-sm text-slate-600">
                                    {Object.entries(event.data).map(([key, value]) => (
                                      <div key={key}>
                                        <span className="font-medium">{key}:</span>{' '}
                                        <span className="font-mono">{String(value)}</span>
                                      </div>
                                    ))}
                                  </div>
                                )}
                              </div>
                              <Badge variant="outline" className="shrink-0">
                                {formatTime(event.timestamp)}
                              </Badge>
                            </div>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </ScrollArea>
            </CardContent>
          </Card>

          {/* Stats & Info */}
          <div className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle>Statistics</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div>
                  <p className="text-sm text-slate-600">Total Events</p>
                  <p className="text-3xl font-bold text-slate-900">{events.length}</p>
                </div>
                <Separator />
                <div>
                  <p className="text-sm text-slate-600">Latest Event</p>
                  <p className="text-sm font-medium text-slate-900 mt-1">
                    {events.length > 0 
                      ? events[events.length - 1].description 
                      : 'None yet'}
                  </p>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Instructions</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3 text-sm text-slate-600">
                <div className="space-y-2">
                  <p className="font-medium text-slate-900">1. Keep this page open</p>
                  <p>This dashboard will show real-time events</p>
                </div>
                <Separator />
                <div className="space-y-2">
                  <p className="font-medium text-slate-900">2. Open the mobile app</p>
                  <p>Launch the Cambodia Gov Portal app on your device</p>
                </div>
                <Separator />
                <div className="space-y-2">
                  <p className="font-medium text-slate-900">3. Go through auth flow</p>
                  <p>Each action will appear here in real-time</p>
                </div>
                <Separator />
                <div className="space-y-2">
                  <p className="font-medium text-slate-900">4. Reset for new demo</p>
                  <p>Click "Clear Events" to start fresh</p>
                </div>
              </CardContent>
            </Card>

            <Card className="bg-blue-50 border-blue-200">
              <CardContent className="pt-6">
                <p className="text-sm text-blue-900">
                  <strong>Demo Mode:</strong> Backend events are simulated. 
                  In production, these would come from your actual XSIM backend.
                </p>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
}

