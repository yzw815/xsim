import { NextRequest, NextResponse } from 'next/server';
import { logStore, LogEntry } from '@/lib/log-store';

// GET - Retrieve logs
export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const category = searchParams.get('category') as LogEntry['category'] | null;
  const level = searchParams.get('level') as LogEntry['level'] | null;
  const limit = parseInt(searchParams.get('limit') || '100', 10);

  let logs = logStore.getAll();

  // Filter by category
  if (category && category !== 'ALL') {
    logs = logs.filter((log) => log.category === category);
  }

  // Filter by level
  if (level && level !== 'ALL') {
    logs = logs.filter((log) => log.level === level);
  }

  // Limit results
  logs = logs.slice(0, limit);

  return NextResponse.json({
    success: true,
    count: logs.length,
    logs,
  });
}

// DELETE - Clear logs
export async function DELETE() {
  logStore.clear();
  return NextResponse.json({
    success: true,
    message: 'Logs cleared',
  });
}

