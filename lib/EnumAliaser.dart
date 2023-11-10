import 'package:todo_calendar_client/models/enums/DecisionType.dart';
import 'package:todo_calendar_client/models/enums/EventType.dart';
import 'package:todo_calendar_client/models/enums/EventStatus.dart';
import 'package:todo_calendar_client/models/enums/GroupType.dart';
import 'package:todo_calendar_client/models/enums/ReportType.dart';
import 'package:todo_calendar_client/models/enums/TaskCurrentStatus.dart';
import 'package:todo_calendar_client/models/enums/TaskType.dart';

final class EnumAliaser{
  String GetAlias(Object enumValue){
    if (enumValue is DecisionType){
      if (enumValue == DecisionType.None){
        return 'Без статуса';
      }
      else if (enumValue == DecisionType.Default){
        return 'По умолчанию';
      }
      else if (enumValue == DecisionType.Apply){
        return 'Собирается посетить';
      }
      else if (enumValue == DecisionType.Default){
        return 'Не будет присутствовать';
      }
    }
    else if (enumValue is EventStatus){
      if (enumValue == EventStatus.None){
        return 'Без статуса';
      }
      else if (enumValue == EventStatus.Cancelled){
        return 'Отменено';
      }
      else if (enumValue == EventStatus.NotStarted){
        return 'Не начато';
      }
      else if (enumValue == EventStatus.WithinReminderOffset){
        return 'Скоро начнется';
      }
      else if (enumValue == EventStatus.Live){
        return 'Идет сейчас';
      }
      else if (enumValue == EventStatus.Finished){
        return 'Завершено';
      }
    }
    else if (enumValue is EventType){
      if (enumValue == EventType.None){
        return 'Без статуса';
      }
      else if (enumValue == EventType.Personal){
        return 'Личное';
      }
      else if (enumValue == EventType.OneToOne){
        return 'Парное';
      }
      else if (enumValue == EventType.StandUp){
        return 'Стэндап команды';
      }
      else if (enumValue == EventType.Meeting){
        return 'Общее собрание';
      }
    }
    else if (enumValue is GroupType){
      if (enumValue == GroupType.None){
        return 'Без статуса';
      }
      else if (enumValue == GroupType.Educational){
        return 'Учебная';
      }
      else if (enumValue == GroupType.Job){
        return 'Рабочая';
      }
    }
    else if (enumValue is ReportType){
      if (enumValue == ReportType.None){
        return 'Без статуса';
      }
      else if (enumValue == ReportType.TasksReport){
        return 'По задачам пользователя';
      }
      else if (enumValue == ReportType.EventsReport){
        return 'По мероприятиям пользователя';
      }
    }
    else if (enumValue is TaskCurrentStatus){
      if (enumValue == TaskCurrentStatus.None){
        return 'Без статуса';
      }
      else if (enumValue == TaskCurrentStatus.ToDo){
        return 'Ожидает выполнения';
      }
      else if (enumValue == TaskCurrentStatus.InProgress){
        return 'В процессе';
      }
      else if (enumValue == TaskCurrentStatus.Review){
        return 'На стадии оценки';
      }
      else if (enumValue == TaskCurrentStatus.Done){
        return 'Выполнена';
      }
    }
    else if (enumValue is TaskType){
      if (enumValue == TaskType.None){
        return 'Без статуса';
      }
      else if (enumValue == TaskType.AbstractGoal){
        return 'Абстрактная цель';
      }
      else if (enumValue == TaskType.MeetingPresense){
        return 'Цель посещения мероприятий';
      }
      else if (enumValue == TaskType.JobComplete){
        return 'Цель в выполнении работы';
      }
    }

    return 'Без статуса';
  }
}