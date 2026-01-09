import 'dart:async';
import 'package:flutter/material.dart';

enum TipoRegistro { mayor, menor }

// ===== Widget auxiliar para resumen =====
Widget resumenFila(String titulo, String valor) {
  final v = valor.trim();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 8),
        Expanded(flex: 5, child: Text(v.isEmpty ? '-' : v)),
      ],
    ),
  );
}

// =====================================================
// Panel derecho: carrusel automático con FadeTransition
// =====================================================
class ActividadesCarousel extends StatefulWidget {
  const ActividadesCarousel({
    super.key,
    required this.imagePaths,
    this.interval = const Duration(seconds: 4),
    this.fadeDuration = const Duration(milliseconds: 700),
    this.borderRadius = 16,
  });

  final List<String> imagePaths;
  final Duration interval;
  final Duration fadeDuration;
  final double borderRadius;

  @override
  State<ActividadesCarousel> createState() => _ActividadesCarouselState();
}

class _ActividadesCarouselState extends State<ActividadesCarousel> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.imagePaths.isNotEmpty) {
      _timer = Timer.periodic(widget.interval, (_) {
        if (!mounted) return;
        setState(() => _index = (_index + 1) % widget.imagePaths.length);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return const Center(child: Text('No hay imágenes en assets/img/'));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: widget.fadeDuration,
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Image.asset(
              widget.imagePaths[_index],
              key: ValueKey(widget.imagePaths[_index]),
              fit: BoxFit.cover,
            ),
          ),
          // Overlay para legibilidad (opcional)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.transparent,
                  Colors.black.withOpacity(0.25),
                ],
              ),
            ),
          ),
          Positioned(
            left: 14,
            bottom: 12,
            right: 14,
            child: Row(
              children: [
                const Icon(Icons.water, color: Colors.white),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Actividades acuáticas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // “Dots” indicador
                Row(
                  children: List.generate(widget.imagePaths.length, (i) {
                    final active = i == _index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(left: 6),
                      width: active ? 16 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active ? Colors.white : Colors.white.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// PANTALLA: Izquierda formulario / Derecha carrusel
// =====================================================
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

  // ===== REQ: Dropdown nivel de experiencia =====
  String? _nivelExperiencia; // Principiante / Medio / Avanzado

  // ===== REQ: Preferencia escuela (radio) =====
  String? _escuela; // Club Nautico / La Ducal / Zona Norte / Aun no lo se

  // ===== REQ: Términos y condiciones =====
  bool _aceptaTerminos = false;

  final List<String> _imagenes = const [
    'assets/img/surf.jpg',
    'assets/img/paddlesurf.jpg',
    'assets/img/windsurf.jpg',
    'assets/img/wingfoil.jpg',
    'assets/img/kitesurf.jpg',
  ];

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
    final hadBirthday = (now.month > nacimiento.month) ||
        (now.month == nacimiento.month && now.day >= nacimiento.day);
    if (!hadBirthday) age--;
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

  Widget _tituloSeccion(String text) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      );

  void _cambiarTipo(TipoRegistro? t) {
    if (t == null) return;
    setState(() => _tipo = t);
    _formKey.currentState?.reset();
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;

    final isMenor = _tipo == TipoRegistro.menor;
    final errFecha =
        _fechaVal(isMenor ? _menorNacimiento : _mayorNacimiento, mayor: !isMenor);
    if (errFecha != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errFecha)),
      );
      return;
    }

    // (Opcional) aunque se valida con FormField, lo dejamos por seguridad
    if (_escuela == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona la escuela donde quieres hacer la actividad'),
        ),
      );
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
                const SizedBox(height: 12),
                const Text('Preferencias',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                resumenFila('Nivel', _nivelExperiencia ?? ''),
                resumenFila('Escuela', _escuela ?? ''),
                resumenFila('Términos aceptados', _aceptaTerminos ? 'Sí' : 'No'),
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
                const SizedBox(height: 12),
                const Text('Preferencias',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                resumenFila('Nivel', _nivelExperiencia ?? ''),
                resumenFila('Escuela', _escuela ?? ''),
                resumenFila('Términos aceptados', _aceptaTerminos ? 'Sí' : 'No'),
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

      // Reset requisitos nuevos
      _nivelExperiencia = null;
      _escuela = null;
      _aceptaTerminos = false;
    });
  }

  // =====================================================
  // Layout responsive: Row (pantalla grande) / Column (móvil)
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro en actividad')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          final form = _buildFormulario();

          final right = Padding(
            padding: const EdgeInsets.all(16),
            child: ActividadesCarousel(
              imagePaths: _imagenes,
              interval: const Duration(seconds: 4),
              fadeDuration: const Duration(milliseconds: 700),
              borderRadius: 18,
            ),
          );

          if (isWide) {
            return Row(
              children: [
                // Izquierda
                Expanded(
                  flex: 3,
                  child: form,
                ),
                // Derecha
                Expanded(
                  flex: 2,
                  child: right,
                ),
              ],
            );
          }

          // Móvil / estrecho: columna
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 420, child: right),
              form,
            ],
          );
        },
      ),
    );
  }

  Widget _buildFormulario() {
    final isMenor = _tipo == TipoRegistro.menor;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          // Para que en modo Row no haya overflow
          children: [
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

            if (!isMenor) ...[
              const Text('Datos del usuario',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              _sp(),
              TextFormField(
                controller: _mayorNombreCtrl,
                decoration: _dec('Nombre'),
                validator: (v) => _reqMin(v, 'Nombre'),
              ),
              _sp(),
              TextFormField(
                controller: _mayorApellidosCtrl,
                decoration: _dec('Apellidos'),
                validator: (v) => _reqMin(v, 'Apellidos'),
              ),
              _sp(),
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
              ),
              _sp(),
              TextFormField(
                controller: _mayorDniCtrl,
                decoration: _dec('DNI / NIE', hint: '12345678Z o X1234567L'),
                textCapitalization: TextCapitalization.characters,
                validator: _dniVal,
              ),
              _sp(),
              TextFormField(
                controller: _mayorEmailCtrl,
                decoration: _dec('Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _emailVal,
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
              ),
            ],

            if (isMenor) ...[
              const Text('Datos del menor',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              _sp(),
              TextFormField(
                controller: _menorNombreCtrl,
                decoration: _dec('Nombre del menor'),
                validator: (v) => _reqMin(v, 'Nombre del menor'),
              ),
              _sp(),
              TextFormField(
                controller: _menorApellidosCtrl,
                decoration: _dec('Apellidos del menor'),
                validator: (v) => _reqMin(v, 'Apellidos del menor'),
              ),
              _sp(),
              InkWell(
                onTap: () => _pickFechaNacimiento(mayor: false),
                child: InputDecorator(
                  decoration: _dec('Fecha nacimiento del menor',
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
              ),
              _sp(),
              TextFormField(
                controller: _tutorApellidosCtrl,
                decoration: _dec('Apellidos del tutor'),
                validator: (v) => _reqMin(v, 'Apellidos del tutor'),
              ),
              _sp(),
              TextFormField(
                controller: _tutorTelefonoCtrl,
                decoration: _dec('Teléfono del tutor', hint: 'Solo dígitos'),
                keyboardType: TextInputType.phone,
                validator: _telefonoVal,
              ),
              _sp(),
              TextFormField(
                controller: _tutorDniCtrl,
                decoration: _dec('DNI / NIE del tutor'),
                textCapitalization: TextCapitalization.characters,
                validator: _dniVal,
              ),
              _sp(),
              TextFormField(
                controller: _tutorEmailCtrl,
                decoration: _dec('Email del tutor'),
                keyboardType: TextInputType.emailAddress,
                validator: _emailVal,
              ),
              _sp(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('¿El menor puede irse solo al acabar la actividad?'),
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
            const Divider(height: 28),

            // =============================
            // REQ 1: Dropdown NIVEL EXPERIENCIA
            // =============================
            _tituloSeccion('Nivel de experiencia'),
            DropdownButtonFormField<String>(
              value: _nivelExperiencia,
              decoration: _dec('Selecciona tu nivel'),
              items: const [
                DropdownMenuItem(value: 'Principiante', child: Text('Principiante')),
                DropdownMenuItem(value: 'Medio', child: Text('Medio')),
                DropdownMenuItem(value: 'Avanzado', child: Text('Avanzado')),
              ],
              onChanged: (v) => setState(() => _nivelExperiencia = v),
              validator: (v) => (v == null) ? 'Selecciona un nivel de experiencia' : null,
            ),

            _sp(),

            // =============================
            // REQ 2: Preferencia ESCUELA (RADIOS)
            // =============================
            _tituloSeccion('Escuela donde quieres hacer la actividad'),
            FormField<String>(
              validator: (v) => (_escuela == null) ? 'Selecciona una escuela' : null,
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Club Náutico'),
                            value: 'Club Náutico',
                            groupValue: _escuela,
                            onChanged: (v) {
                              setState(() => _escuela = v);
                              state.didChange(v);
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Centro de La Ducal'),
                            value: 'Centro de La Ducal',
                            groupValue: _escuela,
                            onChanged: (v) {
                              setState(() => _escuela = v);
                              state.didChange(v);
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Centro Zona Norte'),
                            value: 'Centro Zona Norte',
                            groupValue: _escuela,
                            onChanged: (v) {
                              setState(() => _escuela = v);
                              state.didChange(v);
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Aún no lo sé'),
                            value: 'Aún no lo sé',
                            groupValue: _escuela,
                            onChanged: (v) {
                              setState(() => _escuela = v);
                              state.didChange(v);
                            },
                          ),
                        ],
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 6),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                  ],
                );
              },
            ),

            _sp(),

            // =============================
            // REQ 3: Aceptar Términos (CHECKBOX obligatorio)
            // =============================
            FormField<bool>(
              initialValue: _aceptaTerminos,
              validator: (v) =>
                  (_aceptaTerminos == true) ? null : 'Debes aceptar los términos y condiciones',
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _aceptaTerminos,
                      onChanged: (v) {
                        setState(() => _aceptaTerminos = v ?? false);
                        state.didChange(v ?? false);
                      },
                      title: const Text('Acepto los términos y condiciones / política de privacidad'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                  ],
                );
              },
            ),

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
    );
  }
}
