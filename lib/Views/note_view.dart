import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Views/log_in_view.dart';
import 'package:myapp/Views/new_note_view.dart';

import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:page_transition/page_transition.dart';
import '../Components/note_card.dart';
import '../Res/colors.dart';
import '../View_Model/new_note_view_model.dart';
import '../View_Model/note_view_model.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteViewModel>(context, listen: false).getNotes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteViewModel>(
      builder: (BuildContext context, NoteViewModel provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Notes',
              style: Theme.of(context).textTheme.headline1,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Transform.scale(
                  scale: 1.5,
                  child: Switch(
                    value: provider.isDark,
                    onChanged: (bool value) {
                      provider.setIsDark = value;
                    },
                    activeThumbImage:
                        const AssetImage('assets/images/dark.png'),
                    inactiveThumbImage:
                        const AssetImage('assets/images/light.png'),
                    activeColor: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  provider.logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginView()));
                },
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).textTheme.headline1!.color,
                ),
              ),
            ],
          ),
          body: !provider.isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      children: provider.noteList.map((note) {
                        return NoteCard(
                          userId: provider.userId!,
                          note: note,
                        );
                      }).toList(),
                    ),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.scale,
                  duration: const Duration(milliseconds: 500),
                  alignment: Alignment.bottomRight,
                  child: ChangeNotifierProvider(
                    create: (_) => NewNoteViewModel(),
                    child: NewNoteView(
                      userId: provider.userId!,
                    ),
                  ),
                ),
              );
            },
            backgroundColor: CustomColors.primaryColor,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
