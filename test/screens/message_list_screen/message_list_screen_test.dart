import 'package:dashboard/global_widgets/app_bars/default_app_bar.dart';
import 'package:dashboard/models/message/message.dart';
import 'package:dashboard/models/paginate_data_holder.dart';
import 'package:dashboard/repositories/message_repository.dart';
import 'package:dashboard/resources/helpers/api_exception.dart';
import 'package:dashboard/screens/message_list_screen/message_list_screen.dart';
import 'package:dashboard/screens/message_list_screen/widgets/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';
import '../../helpers/screen_builder.dart';

class MockMessageRepository extends Mock implements MessageRepository {}

void main() {
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
        child: MessageListScreen(messageRepository: messageRepository),
        observer: observer
      );

      when(() => messageRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<Message>.generate(15, (index) => mockDataGenerator.createMessage(index: index)),
          next: "next_url"
      )));

      when(() => messageRepository.paginate(url: any(named: "url")))
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: List<Message>.generate(15, (index) => mockDataGenerator.createMessage(index: index)),
          next: "next_url"
      )));

      when(() => messageRepository.updateMessage(messageIdentifier: any(named: "messageIdentifier")))
        .thenAnswer((_) async => true);

      registerFallbackValue(MockRoute());
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
        .thenThrow(ApiException(error: "Error Occurred!"));
      await screenBuilder.createScreen(tester: tester);

      expect(find.text("Error: Error Occurred!"), findsOneWidget);
    });

    testWidgets("MessageListScreenBody shows no messages widget if no messages", (tester) async {
      List<Message> emptyMessages = [];
      when(() => messageRepository.fetchAll())
        .thenAnswer((_) async => Future.delayed(Duration(milliseconds: 500), () => PaginateDataHolder(
          data: emptyMessages,
          next: null
      )));
      await screenBuilder.createScreen(tester: tester);
      await tester.pump(Duration(milliseconds: 500));

      expect(find.text("No Messages."), findsOneWidget);
    });

    testWidgets("MessageListScreenBody shows messages on success fetch", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byType(MessageWidget), findsWidgets);
    });

    testWidgets("Messages list is scrollable", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(find.byKey(Key("message-0")), findsWidgets);
      await tester.fling(find.byType(CustomScrollView), Offset(0, -500), 3000);
      await tester.pump();
      expect(find.byKey(Key("message-0")), findsNothing);
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets("Messages list fetches more messages when threshold reached", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      verifyNever(() => messageRepository.paginate(url: any(named: "url")));
      await tester.fling(find.text("Message Center"), Offset(0, -3000), 3000);
      await tester.pump(Duration(milliseconds: 250));
      verify(() => messageRepository.paginate(url: any(named: "url"))).called(1);
      await tester.pump(Duration(seconds: 1));
    });
    
    testWidgets("MessageWidget tileColor is white if hasUnread", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ListTile>(find.byKey(Key("message-tile-0"))).tileColor, Colors.white);
    });

    testWidgets("MessageWidget tileColor is grey.shade200 if !hasUnread", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      expect(tester.widget<ListTile>(find.byKey(Key("message-tile-1"))).tileColor, Colors.grey.shade200);
    });

    testWidgets("Tapping on Message Widget pushes MessageScreen", (tester) async {
      await screenBuilder.createScreen(tester: tester);
      await tester.tap(find.byKey(Key("message-0")));
      await tester.pump();
      verify(() => observer.didPush(any(), any()));
    });
  });
}