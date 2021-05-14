import 'package:dashboard/global_widgets/app_bars/bottom_modal_app_bar.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/message_list_screen/bloc/message_list_screen_bloc.dart';
import 'package:dashboard/screens/message_screen/message_screen.dart';
import 'package:dashboard/screens/message_screen/widgets/widgets/message_history/message_history.dart';
import 'package:dashboard/screens/message_screen/widgets/widgets/message_history/widgets/message_bubble.dart';
import 'package:dashboard/screens/message_screen/widgets/widgets/message_input/message_input.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockMessageListScreenBloc extends Mock implements MessageListScreenBloc {}
class MockMessageRepository extends Mock implements MessageRepository {}

void main() {
  group("Message Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late NavigatorObserver observer;
    late Message message;
    late MessageListScreenBloc messageListScreenBloc;
    late MessageRepository messageRepository;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      observer = MockNavigatorObserver();
      message = mockDataGenerator.createMessage(index: 0, numberReplies: 15);
      messageListScreenBloc = MockMessageListScreenBloc();
      messageRepository = MockMessageRepository();
      screenBuilder = ScreenBuilder(
        child: MessageScreen(message: message, messageListScreenBloc: messageListScreenBloc, messageRepository: messageRepository), 
        observer: observer
      );

      registerFallbackValue<MessageListScreenEvent>(MessageUpdated(message: message, messageHistoryRead: true));
      
      when(() => messageListScreenBloc.add(any(that: isA<MessageListScreenEvent>())))
        .thenReturn(null);

      when(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => mockDataGenerator.createReply()));
    });

    testWidgets("MessageScreen creates BottomModalAppBar", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(BottomModalAppBar), findsOneWidget);
    });

    testWidgets("MessageScreenBody creates MessageHistory", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(MessageHistory), findsOneWidget);
    });

    testWidgets("MessageHistory contains ListView", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("ListView is scrollable", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("bubble-1")), findsOneWidget);
      await tester.fling(find.byType(ListView), Offset(0, 200), 3000);
      await tester.pumpAndSettle();
      expect(find.byKey(Key("bubble-1")), findsNothing);
    });

    testWidgets("Message History creates initial Message", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.fling(find.byType(ListView), Offset(0, 1500), 3000);
      await tester.pumpAndSettle();
      expect(find.byKey(Key("initialMessage")), findsOneWidget);
    });

    testWidgets("Message History creates MessageBubbles", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(MessageBubble), findsWidgets);
    });

    testWidgets("MessageScreenBody creates MessageInput", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(MessageInput), findsOneWidget);
    });

    testWidgets("MessageInput creates a CupertinoTextField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(CupertinoTextField), findsOneWidget);
    });
    

    testWidgets("MessageInput can receive text input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      String message = faker.lorem.sentence();
      expect(find.text(message), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), message);
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
    });

    testWidgets("MessageInput creates submit button", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("Submit button is disabled if MessageInput is empty", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      verifyNever(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody")));
    });

    testWidgets("Tapping submitButton with valid input shows CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), faker.lorem.sentence());
      await tester.pump(Duration(milliseconds: 400));
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets("Tapping submitButton with valid input calls messageRepository.addReply", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), faker.lorem.sentence());
      await tester.pump(Duration(milliseconds: 400));
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      verify(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody"))).called(1);
    });

    testWidgets("Tapping submitButton with valid input displays reply in MessageHistory on success", (tester) async {
      String body = faker.lorem.sentence();
      
      when(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => mockDataGenerator.createReply(body: body)));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text(body), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), body);
      await tester.pump(Duration(milliseconds: 400));
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      expect(find.text(body), findsOneWidget);
    });

    testWidgets("Tapping submitButton with valid input displays error toast on fail", (tester) async {
      String body = faker.lorem.sentence();
      
      when(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody")))
        .thenThrow(ApiException(error: "An Error Occurred!"));
      
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("An Error Occurred!"), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), body);
      await tester.pump(Duration(milliseconds: 400));
      await tester.tap(find.byKey(Key("submitButtonKey")));
      await tester.pump(Duration(milliseconds: 500));
      expect(find.text("An Error Occurred!"), findsOneWidget);
      await tester.pump(Duration(seconds: 3));
      expect(find.text("An Error Occurred!"), findsNothing);
    });
  });
}