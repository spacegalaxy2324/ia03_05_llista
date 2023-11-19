// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';
import 'package:ia03_05_llista/models/duty_npc_model.dart';

import 'duty_npc_card.dart';

class DutyNpcList extends StatefulWidget {
  const DutyNpcList({super.key, required this.npcs});

  final List<NPC> npcs;

  @override
  State<DutyNpcList> createState() => _DutyNpcListState();
}

class _DutyNpcListState extends State<DutyNpcList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 50),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: widget.npcs.length,
          itemBuilder: (context, index) {
            return DutyNpcCard(npcs: widget.npcs, index: index);
          },
        ),
      ),
    );
  }
}
