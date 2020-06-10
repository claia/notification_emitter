import 'package:flutter/material.dart';
import 'package:emitterk/services/api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  bool isForAll = false;

  int currentValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("EMISOR DE NOTIFICACIONES".toUpperCase()),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: isForAll
          ? FloatingActionButton(
              child: FaIcon(FontAwesomeIcons.broadcastTower),
              tooltip: "EMITE UNA NOTIFICACIÓN",
              onPressed: _isLoading ? null : () => _emitNotification())
          : FloatingActionButton(
              child: FaIcon(FontAwesomeIcons.paperPlane),
              tooltip: "EMITE UNA NOTIFICACIÓN",
              onPressed:
                  _isLoading ? null : () => _emitNotificationPorFacultad()),
    );
  }

  void _emitNotification() async {
    final value = _formKey.currentState.validate();
    if (!value) return;

    final titleValue = _titleController.value.text;
    final bodyValue = _bodyController.value.text;

    setState(() {
      _isLoading = true;
    });

    final res = await _apiService.emitNotification(titleValue, bodyValue);

    if (res)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Notificacion enviada Correctamente".toUpperCase())));
    else
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
              Text("hubo un error en enviar la notificación".toUpperCase())));

    setState(() {
      _isLoading = false;
      _bodyController.clear();
      _titleController.clear();
    });
  }

  void _emitNotificationPorFacultad() async {
    final value = _formKey.currentState.validate();
    if (!value) return;
    if (currentValue == null) return;

    final titleValue = _titleController.value.text;
    final bodyValue = _bodyController.value.text;

    setState(() {
      _isLoading = true;
    });

    final res = await _apiService.emitNotificationByFaculties(
        titleValue, bodyValue, currentValue);

    if (res)
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Notificacion enviada Correctamente".toUpperCase())));
    else
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content:
              Text("hubo un error en enviar la notificación".toUpperCase())));

    setState(() {
      _isLoading = false;
      _bodyController.clear();
      _titleController.clear();
    });
  }

  Widget _buildBody() {
    final _titleDecoration = InputDecoration(
        labelText: "Titulo".toUpperCase(),
        helperText: "titulo de la notificación".toUpperCase(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)));

    final _bodyDecoration = InputDecoration(
        labelText: "Cuerpo".toUpperCase(),
        helperText: "Cuerpo de la notificación".toUpperCase(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)));

    return SingleChildScrollView(
      child: SafeArea(
        child: _isLoading
            ? LinearProgressIndicator()
            : Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                      child: TextFormField(
                        controller: _titleController,
                        decoration: _titleDecoration,
                        maxLength: 30,
                        validator: (value) {
                          if (value.isEmpty)
                            return "campo requerido".toUpperCase();
                          else
                            return null;
                        },
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                      child: TextFormField(
                        controller: _bodyController,
                        decoration: _bodyDecoration,
                        maxLines: 6,
                        validator: (value) {
                          if (value.isEmpty)
                            return "campo requerido".toUpperCase();
                          else
                            return null;
                        },
                      ),
                    ),
                    Container(
                      child: SwitchListTile(
                          title: Text("¿ENVIAR A TODOS?"),
                          value: isForAll,
                          onChanged: (value) {
                            setState(() {
                              isForAll = value;
                            });
                          }),
                    ),
                    isForAll
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(8.0),
                            child: FutureBuilder<List<Faculties>>(
                              future: _apiService.getFaculties(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return LinearProgressIndicator();

                                return DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    value: currentValue,
                                    hint: Text("SELECCIONA FACULTAD"),
                                    items: snapshot.data.map((item) {
                                      return DropdownMenuItem(
                                          value: item.id,
                                          child: Text(item.name));
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null)
                                        return "campo requerido".toUpperCase();
                                      else
                                        return null;
                                    },
                                    onChanged: (item) {
                                      setState(() {
                                        currentValue = item;
                                      });
                                    });
                              },
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
