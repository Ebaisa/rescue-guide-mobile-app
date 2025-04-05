import 'package:flutter/material.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({Key? key}) : super(key: key);

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final TextEditingController _feedbackController = TextEditingController();
  int _selectedStars = 0;
  String? _recommendation;

  void _submitFeedback() {
    if (_selectedStars == 0 || _recommendation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the feedback form')),
      );
      return;
    }

    // Handle feedback submission
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback submitted!')),
    );

    // Clear fields after submission
    setState(() {
      _feedbackController.clear();
      _selectedStars = 0;
      _recommendation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feedback Input Field
            const Text('Leave your feedback/comments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type here...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Star Rating Section
            const Text('Rate your experience', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(5, (index) {
                int starValue = index + 1;
                return ChoiceChip(
                  label: Text('$starValue Star${starValue > 1 ? 's' : ''}'),
                  selected: _selectedStars == starValue,
                  selectedColor: Colors.orange,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStars = selected ? starValue : 0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),

            // Recommendation Section
            const Text('How likely are you to recommend us?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Not likely', 'Maybe', 'Definitely'].map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: _recommendation == option,
                  selectedColor: Colors.green,
                  onSelected: (selected) {
                    setState(() {
                      _recommendation = selected ? option : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: _submitFeedback,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
