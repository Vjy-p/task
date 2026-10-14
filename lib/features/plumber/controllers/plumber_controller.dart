import 'package:assessment/features/plumber/models/assignment_model.dart';
import 'package:get/get.dart';

class PlumberController extends GetxController {
  bool isLoading = false;
  bool error = false;

  List<AssignmentModel> assignments = [
    AssignmentModel(
      id: 'ACT001',
      title: 'Bathroom Installation',
      code: '#ACT001',
      customerName: 'Suresh Kumar',
      customerNumber: '+91 98765 43210',
      address: 'Anna Nagar, Chennai',
      schedule: 'Today • 10:00 AM – 12:00 PM',
      status: 'In Progress',
      description: 'Install bathroom fittings including washbasin tap, shower, and pipe connections.',
      products: [],
    ),
    AssignmentModel(
      id: 'ACT002',
      title: 'Pipe Repair',
      code: '#ACT002',
      customerName: 'Lakshmi Devi',
      customerNumber: '+91 98765 43211',
      address: 'T. Nagar, Chennai',
      schedule: 'Tomorrow • 11:00 AM',
      status: 'Assigned',
      description:
          'Inspect the damaged water pipe and replace the leaking section.',
      products: [],
    ),
    AssignmentModel(
      id: 'ACT003',
      title: 'Kitchen Fitting',
      code: '#ACT003',
      customerName: 'Arvind Kumar',
      customerNumber: '+91 98765 43212',
      address: 'Adyar, Chennai',
      schedule: 'Completed • Yesterday',
      status: 'Completed',
      description: 'Install kitchen tap and verify there are no leaks.',
      products: [],
    ),
    AssignmentModel(
      id: 'ACT004',
      title: 'Leakage Inspection',
      code: '#ACT004',
      customerName: 'Priya Sharma',
      customerNumber: '+91 98765 43213',
      address: 'Velachery, Chennai',
      schedule: '16 Oct • 09:00 AM',
      status: 'Pending',
      description: 'Inspect the reported bathroom leakage and submit findings.',
      products: [],
    ),
  ];
}
