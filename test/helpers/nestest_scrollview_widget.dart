import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class NestedScrollViewTestWidget extends StatelessWidget {
  const NestedScrollViewTestWidget({Key? key}) : super(key: key);

  static const tabBarViewKey = ValueKey('tabbar_view');

  @override
  Widget build(BuildContext context) {
    const tabs = <String>['Tab 1', 'Tab 2'];

    final nestedScrollView = NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: MultiSliver(
              children: const [
                SliverPinnedHeader(
                    child: Padding(
                        padding: EdgeInsets.all(16), child: Text('Bar 1'))),
                SliverPinnedHeader(
                    child: Padding(
                        padding: EdgeInsets.all(16), child: Text('Bar 2'))),
              ],
            ),
          ),
        ];
      },
      body: TabBarView(
        key: tabBarViewKey,
        children: tabs.map((String name) {
          return Builder(
            builder: (BuildContext context) {
              return CustomScrollView(
                key: PageStorageKey<String>(name),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(name)),
                  )
                ],
              );
            },
          );
        }).toList(),
      ),
    );

    return MaterialApp(
      home: DefaultTabController(
        length: tabs.length,
        child: Scaffold(body: nestedScrollView),
      ),
    );
  }
}
