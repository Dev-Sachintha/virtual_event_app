// REPLACE THE ENTIRE FILE WITH THIS CODE

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // FIX: Added import for DateFormat
import 'package:provider/provider.dart';
import 'package:virtual_event_app/core/config/app_strings.dart'; // FIX: Added import
import 'package:virtual_event_app/core/widgets/custom_button.dart';
import 'package:virtual_event_app/features/events/models/event_model.dart';
import 'package:virtual_event_app/features/events/providers/event_provider.dart';
import 'package:virtual_event_app/features/events/services/event_service.dart';
import 'package:virtual_event_app/utils/validators.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate ?? now),
      );
      if (time != null) {
        setState(() {
          _selectedDate =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          // FIX: Removed const
          const SnackBar(content: Text('Please select a date and time')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final newEvent = EventModel(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dateTime: _selectedDate!,
        bannerUrl:
            'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/400/200',
        isLive: false,
      );

      try {
        await context.read<EventService>().createEvent(newEvent);
        await context.read<EventProvider>().fetchEvents();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            // FIX: Removed const
            const SnackBar(content: Text('Event created successfully!')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            // FIX: Removed const
            SnackBar(content: Text('Failed to create event: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(AppStrings.createEvent)), // FIX: This is now valid
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                // FIX: Removed const
                decoration:
                    const InputDecoration(labelText: AppStrings.eventTitle),
                validator: Validators.requiredField,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                // FIX: Removed const
                decoration: const InputDecoration(
                    labelText: AppStrings.eventDescription),
                maxLines: 5,
                validator: Validators.requiredField,
              ),
              const SizedBox(height: 24),
              Text('Event Date & Time',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Not selected'
                          : DateFormat.yMd().add_jm().format(_selectedDate!),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: AppStrings.saveEvent, // FIX: This is now valid
                onPressed: _saveEvent,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
