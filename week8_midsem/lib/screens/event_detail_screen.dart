import 'package:flutter/material.dart';
import '../models/event.dart';

class EventDetailScreen extends StatelessWidget {
  final CampusEvent event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'event_avatar_${event.id}',
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: themeData.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.event, size: 48, color: themeData.colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              event.name,
              style: themeData.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${event.category}',
              style: themeData.textTheme.titleMedium?.copyWith(
                color: themeData.colorScheme.secondary,
              ),
            ),
            const Divider(height: 32),
            _buildDetailRow(context, Icons.location_on, 'Venue', event.venue),
            const SizedBox(height: 12),
            _buildDetailRow(context, Icons.calendar_today, 'Date & Time', event.date),
            const SizedBox(height: 12),
            _buildDetailRow(context, Icons.sell, 'Ticket Price', 'GHS ${event.price.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildDetailRow(context, Icons.chair, 'Available Seats', '${event.availableSeats} / ${event.totalCapacity}'),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: event.isSoldOut ? Colors.grey : themeData.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: event.isSoldOut
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Successfully reserved ticket for ${event.name}!'),
                            backgroundColor: themeData.colorScheme.primary,
                          ),
                        );
                      },
                child: Text(
                  event.isSoldOut ? 'SOLD OUT' : 'Buy Ticket',
                  style: themeData.textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Built by Yeboah Daniel — ID: 224ES02003711 ',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    final themeData = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: themeData.colorScheme.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: themeData.textTheme.bodySmall),
            Text(value, style: themeData.textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}