import 'package:dashboard/global_widgets/app_bars/bottom_modal_app_bar.dart';
import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/message_list_screen/bloc/message_list_screen_bloc.dart';
import 'package:dashboard/screens/message_list_screen/message_list_screen.dart';
import 'package:dashboard/screens/message_list_screen/widgets/widgets/message_widget.dart';
import 'package:dashboard/screens/message_list_screen/widgets/widgets/widgets/widgets/widgets/message_history/message_history.dart';
import 'package:dashboard/screens/message_list_screen/widgets/widgets/widgets/widgets/widgets/message_history/widgets/message_bubble.dart';
import 'package:dashboard/screens/message_list_screen/widgets/widgets/widgets/widgets/widgets/message_input/message_input.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockMessageRepository extends Mock implements MessageRepository {}
class MockMessage extends Mock implements Message {}

void main() {
  
  Future<void> _goToMessageScreen({required WidgetTester tester}) async {
    await tester.tap(find.byKey(const Key("message-0")));
    await tester.pumpAndSettle();
  }
  
  group("Message List Screen Tests", () {
    late MockDataGenerator mockDataGenerator;
    late MessageRepository messageRepository;
    late NavigatorObserver observer;
    late ScreenBuilder screenBuilder;

    setUp(() {
      mockDataGenerator = MockDataGenerator();
      messageRepository = MockMessageRepository();
      observer = MockNavigatorObserver();
      screenBuilder = ScreenBuilder(
        child: RepositoryProvider(
          create: (_) => messageRepository,
          child: const MessageListScreen(),
        ),
        observer: observer
      );

      when(() => messageRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<Message>.generate(15, (index) => mockDataGenerator.createMessage(index: index, numberReplies: 4)),
          next: "next_url"
      )));

      when(() => messageRepository.paginate(url: any(named: "url")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<Message>.generate(15, (index) => mockDataGenerator.createMessage(index: index)),
          next: "next_url"
      )));

      when(() => messageRepository.updateMessage(messageIdentifier: any(named: "messageIdentifier")))
        .thenAnswer((_) async => true);

      when(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => mockDataGenerator.createReply()));

      registerFallbackValue(MockRoute());
      registerFallbackValue(MessageUpdated(message: MockMessage(), messageHistoryRead: true));
    });

    testWidgets("MessageListScreen creates DefaultAppBar", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(DefaultAppBar), findsOneWidget);
    });

    testWidgets("MessageListScreenBody creates header", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.text("Message Center"), findsOneWidget);
    });

    testWidgets("MessageListScreenBody shows error message on fetch fail", (tester) async {
      when(() => messageRepository.fetchAll())
        .thenThrow(const ApiException(error: "Error Occurred!"));
      await screenBuilder.createScreen(tester: tester);

      expect(find.text("Error: Error Occurred!"), findsOneWidget);
    });

    testWidgets("MessageListScreenBody shows no messages widget if no messages", (tester) async {
      List<Message> emptyMessages = [];
      when(() => messageRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => PaginateDataHolder(
          data: emptyMessages,
          next: null
      )));
      await screenBuilder.createScreen(tester: tester);
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text("No Messages."), findsOneWidget);
    });

    testWidgets("MessageListScreenBody shows messages on success fetch", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(MessageWidget), findsWidgets);
    });

    testWidgets("Messages list is scrollable", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(const Key("message-0")), findsWidgets);
      await tester.fling(find.byType(CustomScrollView), const Offset(0, -500), 3000);
      await tester.pump();
      expect(find.byKey(const Key("message-0")), findsNothing);
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets("Messages list fetches more messages when threshold reached", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      verifyNever(() => messageRepository.paginate(url: any(named: "url")));
      await tester.fling(find.text("Message Center"), const Offset(0, -3000), 3000);
      await tester.pump(const Duration(milliseconds: 250));
      verify(() => messageRepository.paginate(url: any(named: "url"))).called(1);
      await tester.pump(const Duration(seconds: 1));
    });
    
    testWidgets("MessageWidget tileColor is white if hasUnread", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ListTile>(find.byKey(const Key("message-tile-0"))).tileColor, Colors.white);
    });

    testWidgets("MessageWidget tileColor is grey.shade200 if !hasUnread", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ListTile>(find.byKey(const Key("message-tile-1"))).tileColor, Colors.grey.shade200);
    });

    testWidgets("Tapping on Message Widget pushes MessageScreen", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.byKey(const Key("message-0")));
      await tester.pump();
      verify(() => observer.didPush(any(), any()));
    });

    testWidgets("MessageScreen creates BottomModalAppBar", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);
      expect(find.byType(BottomModalAppBar), findsOneWidget);
    });

    testWidgets("MessageScreenBody creates MessageHistory", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);
      expect(find.byType(MessageHistory), findsOneWidget);
    });

    testWidgets("MessageHistory contains ListView", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("ListView is scrollable", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);

      expect(find.byKey(const Key("bubble-1")), findsOneWidget);
      await tester.fling(find.byType(ListView), const Offset(0, 200), 3000);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("bubble-1")), findsNothing);
    });

    testWidgets("Message History creates initial Message", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);

      await tester.fling(find.byType(ListView), const Offset(0, 1500), 3000);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("initialMessage")), findsOneWidget);
    });

    testWidgets("Message History creates MessageBubbles", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);

      expect(find.byType(MessageBubble), findsWidgets);
    });

    testWidgets("MessageScreenBody creates MessageInput", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);
      
      expect(find.byType(MessageInput), findsOneWidget);
    });

    testWidgets("MessageInput creates a CupertinoTextField", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);

      expect(find.byType(CupertinoTextField), findsOneWidget);
    });

    testWidgets("MessageInput can receive text input", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);
      
      String message = faker.lorem.sentence();
      expect(find.text(message), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), message);
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
    });

    testWidgets("MessageInput creates submit button", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);

      expect(find.byKey(const Key("submitButtonKey")), findsOneWidget);
    });

    testWidgets("Submit button is disabled if MessageInput is empty", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);

      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 500));
      verifyNever(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody")));
    });

    testWidgets("Tapping submitButton with valid input shows CircularProgressIndicator", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), faker.lorem.sentence());
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets("Tapping submitButton with valid input calls messageRepository.addReply", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);

      expect(find.byType(CircularProgressIndicator), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), faker.lorem.sentence());
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 500));
      verify(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody"))).called(1);
    });

    testWidgets("Tapping submitButton with valid input displays reply in MessageHistory on success", (tester) async {
      String body = faker.lorem.sentence();
      
      when(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody")))
        .thenAnswer((_) async => Future.delayed(const Duration(milliseconds: 500), () => mockDataGenerator.createReply(body: body)));
      
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);

      expect(find.text(body), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), body);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text(body), findsOneWidget);
    });

    testWidgets("Tapping submitButton with valid input displays error toast on fail", (tester) async {
      String body = faker.lorem.sentence();
      
      when(() => messageRepository.addReply(messageIdentifier: any(named: "messageIdentifier"), replyBody: any(named: "replyBody")))
        .thenThrow(const ApiException(error: "An Error Occurred!"));
      
      await screenBuilder.createScreen(tester: tester);
      await _goToMessageScreen(tester: tester);
      
      expect(find.text("An Error Occurred!"), findsNothing);
      await tester.enterText(find.byType(CupertinoTextField), body);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.byKey(const Key("submitButtonKey")));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text("An Error Occurred!"), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text("An Error Occurred!"), findsNothing);
    });
  });
}