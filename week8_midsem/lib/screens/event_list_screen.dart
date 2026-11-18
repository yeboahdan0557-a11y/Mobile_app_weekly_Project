import 'package:flutter/material.dart';
import '../models/event.dart';
import 'event_detail_screen.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CampusEvent> eventsList = CampusEvent.sampleEvents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Fest Events'),
      ),
      body: eventsList.isEmpty
          ? Center(
              child: Text(
                'No events available right now.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth >= 600;

                if (isWideScreen) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: eventsList.length,
                    itemBuilder: (context, index) {
                      return EventTile(event: eventsList[index]);
                    },
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: eventsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EventTile(event: eventsList[index]),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}

class EventTile extends StatelessWidget {
  final CampusEvent event;

  const EventTile({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Stack(
          children: [
            Hero(
              tag: 'event_avatar_${event.id}',
              child: CircleAvatar(
                radius: 28,
                backgroundColor: themeData.colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.code, color: themeData.colorScheme.primary),
              ),
            ),
            // Variant 0: Green live indicator badge
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          event.name,
          style: themeData.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(event.venue, style: themeData.textTheme.bodyMedium),
            const SizedBox(height: 2),
            Text(event.date, style: themeData.textTheme.bodySmall),
            const SizedBox(height: 6),
            event.isSoldOut
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SOLD OUT',
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Text(
                    'GHS ${event.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: themeData.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          );
        },
      ),
    );
  }
}