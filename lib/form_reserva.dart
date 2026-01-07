import 'package:flutter/material.dart';

enum TipoRegistro { mayor, menor }

// =====================================================
// Widget auxiliar para mostrar filas del resumen
// =====================================================
Widget resumenFila(String titulo, String valor) {
  final v = valor.trim();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: Text(v.isEmpty ? '-' : v),
        ),
      ],
    ),
  );
}

class RegistroActividadPage extends StatefulWidget {
  const RegistroActividadPage({super.key});

  @override
  State<RegistroActividadPage> createState() => _RegistroActividadPageState();
}

class _RegistroActividadPageState extends State<RegistroActividadPage> {
  final _formKey = GlobalKey<FormState>();

  TipoRegistro _tipo = TipoRegistro.mayor;

  // ====== MAYOR ======
  final _mayorNombreCtrl = TextEditingController();
  final _mayorApellidosCtrl = TextEditingController();
  final _mayorTelefonoCtrl = TextEditingController();
  final _mayorDniCtrl = TextEditingController();
  final _mayorEmailCtrl = TextEditingController();
  final _mayorPassCtrl = TextEditingController();
  DateTime? _mayorNacimiento;

  // ====== MENOR ======
  final _menorNombreCtrl = TextEditingController();
  final _menorApellidosCtrl = TextEditingController();
  final _menorDniCtrl = TextEditingController();
  final _menorPassCtrl = TextEditingController();
  DateTime? _menorNacimiento;

  // Tutor legal
  final _tutorNombreCtrl = TextEditingController();
  final _tutorApellidosCtrl = TextEditingController();
  final _tutorTelefonoCtrl = TextEditingController();
  final _tutorDniCtrl = TextEditingController();
  final _tutorEmailCtrl = TextEditingController();

  // Extra menor
  bool _puedeIrseSolo = false;
  final _observacionesCtrl = TextEditingController();

  bool _passVisible = false;

  @override
  void dispose() {
    _mayorNombreCtrl.dispose();
    _mayorApellidosCtrl.dispose();
    _mayorTelefonoCtrl.dispose();
    _mayorDniCtrl.dispose();
    _mayorEmailCtrl.dispose();
    _mayorPassCtrl.dispose();

    _menorNombreCtrl.dispose();
    _menorApellidosCtrl.dispose();
    _menorDniCtrl.dispose();
    _menorPassCtrl.dispose();

    _tutorNombreCtrl.dispose();
    _tutorApellidosCtrl.dispose();
    _tutorTelefonoCtrl.dispose();
    _tutorDniCtrl.dispose();
    _tutorEmailCtrl.dispose();

    _observacionesCtrl.dispose();
    super.dispose();
  }

  // ===== Utilidades =====
  String _fmtFecha(DateTime? d) {
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd/$mm/$yy';
  }

  int _edad(DateTime nacimiento) {
    final now = DateTime.now();
    int age = now.year - nacimiento.year;
    final hasHadBirthdayThisYear =
        (now.month > nacimiento.month) ||
            (now.month == nacimiento.month && now.day >= nacimiento.day);
    if (!hasHadBirthdayThisYear) age--;
    return age;
  }

  Future<void> _pickFechaNacimiento({required bool mayor}) async {
    final initial = mayor
        ? (_mayorNacimiento ?? DateTime(DateTime.now().year - 18, 1, 1))
        : (_menorNacimiento ?? DateTime(DateTime.now().year - 10, 1, 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
      helpText: 'Selecciona fecha de nacimiento',
    );

    if (picked == null) return;

    setState(() {
      if (mayor) {
        _mayorNacimiento = picked;
      } else {
        _menorNacimiento = picked;
      }
    });
  }

  // ===== Validadores =====
  String? _reqMin(String? v, String label, {int min = 2}) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return '$label es obligatorio';
    if (value.length < min) return '$label: mínimo $min caracteres';
    return null;
  }

  String? _telefonoVal(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Teléfono es obligatorio';
    final re = RegExp(r'^\d{9,15}$');
    if (!re.hasMatch(value)) return 'Teléfono no válido (solo dígitos)';
    return null;
  }

  String? _emailVal(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email es obligatorio';
    final re = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!re.hasMatch(value)) return 'Email no válido';
    return null;
  }

  String? _dniVal(String? v) {
    final value = (v ?? '').trim().toUpperCase();
    if (value.isEmpty) return 'DNI/NIE es obligatorio';
    final re = RegExp(r'^(\d{8}[A-Z]|[XYZ]\d{7}[A-Z])$');
    if (!re.hasMatch(value)) return 'DNI/NIE no válido';
    return null;
  }

  String? _passVal(String? v) {
    final value = (v ?? '');
    if (value.trim().isEmpty) return 'Contraseña es obligatoria';
    if (value.length < 6) return 'Contraseña: mínimo 6 caracteres';
    return null;
  }

  String? _fechaVal(DateTime? d, {required bool mayor}) {
    if (d == null) return 'Fecha de nacimiento obligatoria';
    final e = _edad(d);

    if (mayor && e < 18) return 'Debe ser mayor de edad (18+)';
    if (!mayor && e >= 18) return 'Debe ser menor de edad (<18)';
    return null;
  }

  InputDecoration _dec(String label, {String? hint, Widget? suffixIcon}) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
      );

  Widget _sp() => const SizedBox(height: 12);

  void _cambiarTipo(TipoRegistro? t) {
    if (t == null) return;
    setState(() => _tipo = t);
    _formKey.currentState?.reset(); // opcional
  }

  // =====================================================
  // ENVÍO: valida -> muestra resumen -> confirmar -> "envía"
  // =====================================================
  void _enviar() {
    // Validación de campos (TextFormField)
    if (!_formKey.currentState!.validate()) return;

    // Validación extra: fecha nacimiento acorde a mayor/menor
    final isMenor = _tipo == TipoRegistro.menor;
    final errFecha = _fechaVal(isMenor ? _menorNacimiento : _mayorNacimiento,
        mayor: !isMenor);
    if (errFecha != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errFecha)));
      return;
    }

    _mostrarResumen();
  }

  void _mostrarResumen() {
    final isMenor = _tipo == TipoRegistro.menor;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Resumen del registro'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMenor) ...[
                const Text('Datos del participante',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                resumenFila('Nombre', _mayorNombreCtrl.text),
                resumenFila('Apellidos', _mayorApellidosCtrl.text),
                resumenFila('Fecha nac.', _fmtFecha(_mayorNacimiento)),
                resumenFila('Teléfono', _mayorTelefonoCtrl.text),
                resumenFila('DNI/NIE', _mayorDniCtrl.text.toUpperCase()),
                resumenFila('Email', _mayorEmailCtrl.text),
                resumenFila('Contraseña', '••••••••'),
              ],
              if (isMenor) ...[
                const Text('Datos del menor',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                resumenFila('Nombre', _menorNombreCtrl.text),
                resumenFila('Apellidos', _menorApellidosCtrl.text),
                resumenFila('Fecha nac.', _fmtFecha(_menorNacimiento)),
                resumenFila('DNI/NIE', _menorDniCtrl.text.toUpperCase()),
                resumenFila('Contraseña', '••••••••'),
                const SizedBox(height: 12),
                const Text('Tutor legal',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                resumenFila('Nombre', _tutorNombreCtrl.text),
                resumenFila('Apellidos', _tutorApellidosCtrl.text),
                resumenFila('Teléfono', _tutorTelefonoCtrl.text),
                resumenFila('DNI/NIE', _tutorDniCtrl.text.toUpperCase()),
                resumenFila('Email', _tutorEmailCtrl.text),
                const SizedBox(height: 12),
                resumenFila('Puede irse solo', _puedeIrseSolo ? 'Sí' : 'No'),
                resumenFila('Observaciones', _observacionesCtrl.text),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Modificar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmarEnvio();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _confirmarEnvio() {
    // Aquí conectarías Firebase/API. Por ahora confirmación visual:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro enviado correctamente')),
    );

    _limpiarTodo();
  }

  void _limpiarTodo() {
    _formKey.currentState?.reset();

    _mayorNombreCtrl.clear();
    _mayorApellidosCtrl.clear();
    _mayorTelefonoCtrl.clear();
    _mayorDniCtrl.clear();
    _mayorEmailCtrl.clear();
    _mayorPassCtrl.clear();
    _mayorNacimiento = null;

    _menorNombreCtrl.clear();
    _menorApellidosCtrl.clear();
    _menorDniCtrl.clear();
    _menorPassCtrl.clear();
    _menorNacimiento = null;

    _tutorNombreCtrl.clear();
    _tutorApellidosCtrl.clear();
    _tutorTelefonoCtrl.clear();
    _tutorDniCtrl.clear();
    _tutorEmailCtrl.clear();

    _observacionesCtrl.clear();

    setState(() {
      _puedeIrseSolo = false;
      _tipo = TipoRegistro.mayor;
      _passVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMenor = _tipo == TipoRegistro.menor;

    return Scaffold(
      appBar: AppBar(title: const Text('Registro en actividad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Selector Mayor/Menor
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tipo de registro',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      RadioListTile<TipoRegistro>(
                        title: const Text('Mayor de edad'),
                        value: TipoRegistro.mayor,
                        groupValue: _tipo,
                        onChanged: _cambiarTipo,
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<TipoRegistro>(
                        title: const Text('Menor de edad'),
                        value: TipoRegistro.menor,
                        groupValue: _tipo,
                        onChanged: _cambiarTipo,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              _sp(),

              // ===== Sección Mayor =====
              if (!isMenor) ...[
                const Text('Datos del usuario',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                _sp(),
                TextFormField(
                  controller: _mayorNombreCtrl,
                  decoration: _dec('Nombre'),
                  validator: (v) => _reqMin(v, 'Nombre'),
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _mayorApellidosCtrl,
                  decoration: _dec('Apellidos'),
                  validator: (v) => _reqMin(v, 'Apellidos'),
                  textInputAction: TextInputAction.next,
                ),
                _sp(),

                // Fecha nacimiento (botón)
                InkWell(
                  onTap: () => _pickFechaNacimiento(mayor: true),
                  child: InputDecorator(
                    decoration: _dec('Fecha de nacimiento',
                        hint: 'Selecciona una fecha',
                        suffixIcon: const Icon(Icons.calendar_month)),
                    child: Text(
                      _mayorNacimiento == null
                          ? 'Pulsa para seleccionar'
                          : _fmtFecha(_mayorNacimiento),
                    ),
                  ),
                ),
                _sp(),

                TextFormField(
                  controller: _mayorTelefonoCtrl,
                  decoration: _dec('Teléfono', hint: 'Solo dígitos'),
                  keyboardType: TextInputType.phone,
                  validator: _telefonoVal,
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _mayorDniCtrl,
                  decoration:
                      _dec('DNI / NIE', hint: '12345678Z o X1234567L'),
                  textCapitalization: TextCapitalization.characters,
                  validator: _dniVal,
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _mayorEmailCtrl,
                  decoration: _dec('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailVal,
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _mayorPassCtrl,
                  obscureText: !_passVisible,
                  decoration: _dec(
                    'Contraseña',
                    hint: 'Mín. 6 caracteres',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _passVisible = !_passVisible),
                      icon: Icon(_passVisible ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  validator: _passVal,
                  textInputAction: TextInputAction.done,
                ),
              ],

              // ===== Sección Menor + Tutor =====
              if (isMenor) ...[
                const Text('Datos del menor',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                _sp(),
                TextFormField(
                  controller: _menorNombreCtrl,
                  decoration: _dec('Nombre del menor'),
                  validator: (v) => _reqMin(v, 'Nombre del menor'),
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _menorApellidosCtrl,
                  decoration: _dec('Apellidos del menor'),
                  validator: (v) => _reqMin(v, 'Apellidos del menor'),
                  textInputAction: TextInputAction.next,
                ),
                _sp(),

                // Fecha nacimiento menor
                InkWell(
                  onTap: () => _pickFechaNacimiento(mayor: false),
                  child: InputDecorator(
                    decoration: _dec('Fecha de nacimiento del menor',
                        hint: 'Selecciona una fecha',
                        suffixIcon: const Icon(Icons.calendar_month)),
                    child: Text(
                      _menorNacimiento == null
                          ? 'Pulsa para seleccionar'
                          : _fmtFecha(_menorNacimiento),
                    ),
                  ),
                ),
                _sp(),

                TextFormField(
                  controller: _menorDniCtrl,
                  decoration: _dec('DNI / NIE del menor'),
                  textCapitalization: TextCapitalization.characters,
                  validator: _dniVal,
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _menorPassCtrl,
                  obscureText: !_passVisible,
                  decoration: _dec(
                    'Contraseña (cuenta del menor)',
                    hint: 'Mín. 6 caracteres',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _passVisible = !_passVisible),
                      icon: Icon(_passVisible ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  validator: _passVal,
                  textInputAction: TextInputAction.next,
                ),
                _sp(),

                const Divider(height: 28),
                const Text('Datos del tutor legal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                _sp(),
                TextFormField(
                  controller: _tutorNombreCtrl,
                  decoration: _dec('Nombre del tutor'),
                  validator: (v) => _reqMin(v, 'Nombre del tutor'),
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _tutorApellidosCtrl,
                  decoration: _dec('Apellidos del tutor'),
                  validator: (v) => _reqMin(v, 'Apellidos del tutor'),
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _tutorTelefonoCtrl,
                  decoration: _dec('Teléfono del tutor', hint: 'Solo dígitos'),
                  keyboardType: TextInputType.phone,
                  validator: _telefonoVal,
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _tutorDniCtrl,
                  decoration: _dec('DNI / NIE del tutor'),
                  textCapitalization: TextCapitalization.characters,
                  validator: _dniVal,
                  textInputAction: TextInputAction.next,
                ),
                _sp(),
                TextFormField(
                  controller: _tutorEmailCtrl,
                  decoration: _dec('Email del tutor'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailVal,
                  textInputAction: TextInputAction.done,
                ),
                _sp(),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                      '¿El menor puede irse solo al acabar la actividad?'),
                  value: _puedeIrseSolo,
                  onChanged: (v) => setState(() => _puedeIrseSolo = v),
                ),
                _sp(),
                TextFormField(
                  controller: _observacionesCtrl,
                  decoration: _dec('Observaciones',
                      hint: 'Alergias, medicación, condiciones, etc.'),
                  minLines: 3,
                  maxLines: 6,
                ),
              ],

              _sp(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _enviar,
                      icon: const Icon(Icons.check),
                      label: const Text('Enviar registro'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _limpiarTodo,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Limpiar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
