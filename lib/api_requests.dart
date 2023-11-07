import 'package:http/http.dart' as http;

// запросы связанные с пользователем
Future<String> registerNewUser() async {
  final url = Uri.parse('http://localhost:5201/users/register');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'email': 'parahinvaler5@gmail.com',
        'name': 'valer5',
        'password': 'tigeroff2002',
        'phone_number': '8-903-225-50-27'
      }
  );
  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<String> loginUser() async {
  final url = Uri.parse('http://localhost:5201/users/login');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'email': 'parahinvaleri5@gmail.com',
        'password': 'tigeroff2002'
      }
  );
  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<void> updateUserInfo() async {
  final url = Uri.parse('http://localhost:5201/users/get_info');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body:
    {
      'user_id': 1,
      'token': '0895439408',
      'name': 'Kiriusha'
    },
  );

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> getUserInfo() async {
  final url = Uri.parse('http://localhost:5201/users/get_info');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body:
    {
      'user_id': 1,
      'token': '0895439408'
    },
  );

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// запросы связанные с группой
Future<String> addNewGroup() async {
  final url = Uri.parse('http://localhost:5201/groups/create');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 1,
        'token': '0895439408',
        'group_name': 'Add dot net please',
        'group_type': 'Job'
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<String> updateGroupParams() async {
  final url = Uri.parse('http://localhost:5201/groups/update_group_params');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 3,
        'token': '2112168000',
        'group_id': 15,
        'group_type': 'Educational'
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<String> deleteGroupParticipant() async {
  final url = Uri.parse('http://localhost:5201/groups/delete_participant');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 1,
        'token': '0895439408',
        'group_id': 14,
        'participant_id': 1
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<void> getGroupInfo() async {
  final url = Uri.parse('http://localhost:5201/groups/get_group_info');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 1,
        'token': '0895439408',
        'group_id': 10
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// запросы связанные с группой
Future<String> addNewTask() async {
  final url = Uri.parse('http://localhost:5201/tasks/create');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 1,
        'token': '0895439408',
        'caption': 'Create new api specification',
        'description': 'Create new api asp .net core specification',
        'task_type': 'JobComplete',
        'task_status': 'ToDo',
        'implementer_id': 3
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<String> updateTaskParams() async {
  final url = Uri.parse('http://localhost:5201/tasks/update_task_params');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 1,
        'token': '0895439408',
        'task_id': 4,
        'task_status': 'InProgress',
        'implementer_id': 2
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<void> getTaskInfo() async {
  final url = Uri.parse('http://localhost:5201/tasks/get_task_info');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 1,
        'token': '0895439408',
        'task_id': 4
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// запросы связанные с мерприятиями
Future<String> scheduleNewEvent() async {
  final url = Uri.parse('http://localhost:5201/events/schedule_new');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 1,
        'token': '0895439408',
        'caption': 'New december olimpiad discussion',
        'description': 'Discussion about ICPC decemper tour olimpiad',
        'scheduled_start': '2023-11-05T18:00+00:00',
        'duration': '00:30:00',
        'event_type': 'OneToOne',
        'event_status': 'NotStarted',
        'group_id': 10,
        'guests_ids': [2]
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<String> updateEventParams() async {
  final url = Uri.parse('http://localhost:5201/events/update_event_params');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'event_id': 3,
        'user_id': 1,
        'token': '0895439408',
        'scheduled_start': '2023-11-10T00:00:00+00:00',
        'group_id': 10
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<String> addNewGuestToEvent() async {
  final url = Uri.parse('http://localhost:5201/events/update_event_params');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'event_id': 8,
        'user_id': 1,
        'token': '0895439408',
        'guests_ids': [3]
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<String> changeUserDecisionForEvent() async {
  final url = Uri.parse('http://localhost:5201/events/change_user_decision_for_event');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'event_id': 8,
        'user_id': 1,
        'token': '0895439408',
        'decision_type': 'deny'
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<void> getEventInfo() async {
  final url = Uri.parse('http://localhost:5201/events/get_event_info');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 1,
        'token': '0895439408',
        'event_id': 3
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

// запросы связанные с мерприятиями
Future<String> addNewReport() async {
  final url = Uri.parse('http://localhost:5201/reports/perform_new');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 2,
        'token': '0696142000',
        'report_type': 'EventsReport',
        'begin_moment': '2023-10-22T00:00:00+00:00',
        'end_moment': '2023-11-06T00:00:00+00:00'
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
    return response.body.toString();
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return response.body.toString();
  }
}

Future<void> getReportInfo() async {
  final url = Uri.parse('http://localhost:5201/reports/get_report_info');
  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body:
      {
        'user_id': 1,
        'token': '0895439408',
        'report_id': 11
      }
  );

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
