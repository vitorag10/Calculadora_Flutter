class Memory {
  static const operations = const ['%', '/', 'x', '-', '+', '='];

  final _buffer = [0.0, 0.0];
  int _bufferIndex = 0;
  String? _operation;
  String _value = '0';
  bool _wipeValue = false;

  void applyCommand(String command) {
    if (command == 'AC') {
      _allClear();
    } else if (operations.contains(command)) {
      _setOperation(command);
    } else {
      _addDigit(command);
    }
  }

  void _setOperation(String newOperation) {
    if (_bufferIndex == 0) {
      _operation = newOperation;
      _bufferIndex = 1;
    } else {
      _buffer[0] = _calculate();
      _buffer[1] = 0.0;
      _value = _buffer[0].toString();
      _value = _value.endsWith('.0') ? _value.split('.')[0] : _value;

      bool isEqualSign = newOperation == '=';
      _operation = isEqualSign ? null : newOperation;
      _bufferIndex = isEqualSign ? 0 : 1;
    }

    _wipeValue = true;
  }

  void _addDigit(String digit) {
    final isDot = digit == ',';
    final wipeValue = (_value == '0' && !isDot) || _wipeValue;

    if (isDot && _value.contains(',') && !wipeValue) {
      return;
    }

    final emptyValue = isDot ? '0' : '';
    final currentValue = wipeValue ? emptyValue : _value;
    _value = currentValue + digit;
    _wipeValue = false;

    _buffer[_bufferIndex] = double.tryParse(_value.replaceAll(',', '.')) ?? 0;
  }

  void _allClear() {
    _value = '0';
    _buffer.setAll(0, [0.0, 0.0]);
    _operation = null;
    _bufferIndex = 0;
    _wipeValue = false;
  }

  _calculate() {
    switch (_operation) {
      case '%':
        return _buffer[0] % _buffer[1];
      case '/':
        return _buffer[0] / _buffer[1];
      case 'x':
        return _buffer[0] * _buffer[1];
      case '-':
        return _buffer[0] - _buffer[1];
      case '+':
        return _buffer[0] + _buffer[1];
      default:
        return _buffer[0];
    }
  }

  String get value {
    return _value;
  }
}
