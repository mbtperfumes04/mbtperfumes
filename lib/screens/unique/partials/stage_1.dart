import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/providers/custom_product_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/custom_product_model.dart';
import '../../../providers/notes_scent_provider.dart';

class CustomStage1 extends StatefulWidget {
  const CustomStage1({super.key});

  @override
  State<CustomStage1> createState() => _CustomStage1State();
}

class _CustomStage1State extends State<CustomStage1> {
  int touchedIndex = -1;
  bool openedInfo = false;

  List<PieChartSectionData> showingSections({
    required List<CustomScentItem> items,
    required int touchedIndex,
    required double screenWidth,
  }) {
    const groupPercentages = {
      'Top': 40.0,
      'Middle': 30.0,
      'Base': 30.0,
    };

    const groupColors = {
      'Top': Colors.orange,
      'Middle': Colors.red,
      'Base': Colors.brown,
    };

    final grouped = <String, List<CustomScentItem>>{
      'Top': [],
      'Middle': [],
      'Base': [],
    };

    for (var item in items) {
      if (grouped.containsKey(item.noteType)) {
        grouped[item.noteType]!.add(item);
      }
    }

    List<PieChartSectionData> sections = [];
    int sectionIndex = 0;

    for (var noteType in ['Top', 'Middle', 'Base']) {
      final scentList = grouped[noteType] ?? [];
      final totalPercentage = groupPercentages[noteType] ?? 0.0;

      if (scentList.isEmpty) {
        sections.add(PieChartSectionData(
          color: Colors.grey.shade300,
          value: totalPercentage,
          radius: 50.0,
          showTitle: false,
          badgeWidget: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenWidth * 0.03,
            ),
            child: Text(
              '${totalPercentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          badgePositionPercentageOffset: 1,
        ));
        sectionIndex++;
        continue;
      }

      final sectionValue = totalPercentage / scentList.length;

      for (var item in scentList) {
        final isTouched = sectionIndex == touchedIndex;
        final radius = isTouched ? 60.0 : 50.0;
        final fontSize = isTouched ? 25.0 : 16.0;

        sections.add(PieChartSectionData(
          color: groupColors[noteType]!.withOpacity(1.0 - (0.15 * scentList.indexOf(item))),
          value: sectionValue,
          radius: radius,
          showTitle: false,
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.3
          ),
          badgeWidget: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              print('test');
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.025,
                vertical: screenWidth * 0.025,
              ),
              child: Text(
                '${sectionValue.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
          badgePositionPercentageOffset: 1,
        ));

        sectionIndex++;
      }
    }

    return sections;
  }

  void open() {
    print('opened');
  }
  
  @override
  Widget build(BuildContext context) {
    final notesScentProvider = Provider.of<NotesScentsProvider>(context);
    final customProductProvider = Provider.of<CustomProductProvider>(context);

    List<CustomScentItem> allScents = customProductProvider.selectedScents;

    final sections = showingSections(
      items: allScents,
      touchedIndex: -1,
      screenWidth: screenWidth,
    );

    if (touchedIndex >= sections.length) {
      touchedIndex = -1;
    }

    final updatedSections = List.generate(sections.length, (index) {
      final section = sections[index];
      final isTouched = index == touchedIndex;

      return section.copyWith(
        radius: isTouched ? 60.0 : 50.0,
        badgeWidget: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenWidth * 0.03,
          ),
          child: Text(
            '${section.value.toStringAsFixed(0)}%',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: isTouched ? 25.0 : 16.0,
            ),
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Text('Notes Selection',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w700,
                      // color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05
                    ),
                    child: Text("You can choose multiple scents within each note to create a more balanced and complex fragrance.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: screenWidth * 0.033,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF808080)
                        // color: Theme.of(context).colorScheme.primary
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            AspectRatio(
              aspectRatio: 1.5,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: StatefulBuilder(
                        builder: (context, setLocalState) {
                          final base = showingSections(
                            items: allScents,
                            touchedIndex: -1,
                            screenWidth: MediaQuery.of(context).size.width,
                          );

                          final safeIndex = (touchedIndex >= 0 && touchedIndex < base.length)
                              ? touchedIndex
                              : -1;

                          final sectionsToDraw = showingSections(
                            items: allScents,
                            touchedIndex: safeIndex,
                            screenWidth: MediaQuery.of(context).size.width,
                          );

                          return PieChart(
                            key: ValueKey(sectionsToDraw.length),
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (evt, resp) {
                                  setState(() {
                                    if (resp == null || resp.touchedSection == null) {
                                      touchedIndex = -1;
                                    } else {
                                      final newIdx = resp.touchedSection!.touchedSectionIndex;
                                      touchedIndex = (newIdx < sectionsToDraw.length) ? newIdx : -1;
                                    }
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 0,
                              centerSpaceRadius: MediaQuery.of(context).size.width * 0.17,
                              sections: sectionsToDraw,
                            ),
                          );
                        },
                      )
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: screenHeight * 0.02
              ),
              child: Column(
                children: [
                  NoteSelector(
                    noteType: 'Top',
                    desc: "These are notes that are light, initial aromas you smell first that evaporate quickly",
                    color: Colors.orange,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  NoteSelector(
                    noteType: 'Middle',
                    desc: "These notes are the heart of the fragrance, developing after the top notes fade and lasting longer",
                    color: Colors.red,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  NoteSelector(
                    noteType: 'Base',
                    desc: "These notes are the deep, long-lasting scents that form the foundation of the fragrance.",
                    color: Colors.brown,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.15),
          ],
        ),
      ),
    );
  }
}

class NoteSelector extends StatelessWidget {
  final String noteType;
  final String desc;
  final Color color;
  final double screenHeight;
  final double screenWidth;

  const NoteSelector({
    required this.noteType,
    required this.desc,
    required this.color,
    required this.screenHeight,
    required this.screenWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notesScentProvider = Provider.of<NotesScentsProvider>(context);
    final customProductProvider = Provider.of<CustomProductProvider>(context);

    final filteredNotes = notesScentProvider.items.where((note) => note.noteType == noteType).toList();

    String selectedNotes = customProductProvider.selectedScents
        .where((scent) => scent.noteType == noteType)
        .map((scent) => scent.scent.name)
        .join(', ');

    return Container(
      child: Column(
        children: [
          Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(noteType,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                Container(
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        offset: Offset(0, 0),
                                        spreadRadius: 1,
                                        blurRadius: 9
                                      )
                                    ]
                                  ),
                                  width: screenWidth * 0.06,
                                  height: screenWidth * 0.06,
                                )
                              ],
                            ),
                            Text('[${selectedNotes.isEmpty ? 'None Selected' : selectedNotes}]',
                              style: TextStyle(
                                color: const Color(0xFF808080)
                              ),
                            )
                          ],
                        ),
                        Text(desc,
                          style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w300,
                            color: const Color(0xFF808080)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.013),
          Container(
            height: screenHeight * 0.055,
            width: screenWidth,
            child: ListView.builder(
              itemCount: filteredNotes.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];

                return InkWell(
                  onTap: () {
                    if (customProductProvider.selectedScents.any((scent) => scent.id == note.id)) {
                      customProductProvider.removeScent(note.id ?? '');
                    } else {

                      if(customProductProvider.selectedScents.where((scent) => scent.noteType == noteType).length > 2) {
                        return;
                      }

                      customProductProvider.addScent(
                        CustomScentItem(
                          id: note.id ?? '',
                          scent: note,
                          value: 0,
                          noteType: noteType,
                        ),
                      );
                    }
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? screenWidth * 0.05 : screenWidth * 0.03
                    ),
                    decoration: BoxDecoration(
                      color: customProductProvider.selectedScents.any((scent) => scent.id == note.id)
                          ? Colors.black
                          : const Color(0xFF808080).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          note.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.04,
                            fontWeight: customProductProvider.selectedScents.any((scent) => scent.id == note.id)
                                ? FontWeight.w600 : FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
