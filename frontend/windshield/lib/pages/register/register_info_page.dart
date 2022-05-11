import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import 'package:windshield/main.dart';
import 'package:windshield/models/provinces.dart';
import 'package:windshield/styles/theme.dart';

class RegisterInfoPage extends StatelessWidget {
  const RegisterInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: MyTheme.majorBackground,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  const Icon(Icons.shield_sharp, size: 25, color: Colors.white),
                  Text(
                    ' WINDSHIELD',
                    style: MyTheme.whiteTextTheme.headline2,
                  ),
                ],
              ),
              Text(
                'ข้อมูลส่วนตัว',
                style: MyTheme.whiteTextTheme.headline2,
              ),
              const Expanded(
                child: FormInfo(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormInfo extends ConsumerStatefulWidget {
  const FormInfo({Key? key}) : super(key: key);

  @override
  _FormInfoState createState() => _FormInfoState();
}

class _FormInfoState extends ConsumerState {
  final _formKey = GlobalKey<FormState>();
  final now = DateTime.now().year;
  String _province = '1';
  String _status = '';
  String _occuType = '';
  int _family = 0;
  int _year = DateTime.now().year;

  _updateStatus(String val) {
    _status = val;
  }

  _updateFamily(int val) {
    _family = val;
  }

  _updateOccu(String val) {
    _occuType = val;
  }

  late final Future<List<Province>?> provFuture =
      ref.read(apiProvider).getProvinces();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    'จังหวัด',
                    style: MyTheme.whiteTextTheme.headline4,
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: FutureBuilder<List<Province>?>(
                    // future: ref.read(apiProvider).getProvinces(),
                    future: provFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.data == null) {
                        return const Text('Error');
                      } else {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: const Color.fromARGB(255, 82, 84, 255),
                          ),
                          child: DropdownButtonFormField<String>(
                            style: MyTheme.whiteTextTheme.headline4,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            items: snapshot.data!
                                .map((prov) => DropdownMenuItem<String>(
                                      child: Text(
                                        prov.name,
                                      ),
                                      value: prov.id,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _province = value!;
                              });
                            },
                            value: _province,
                            isExpanded: false,
                            hint: const Text('จังหวัด'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    'ปีเกิด',
                    style: MyTheme.whiteTextTheme.headline4,
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: const Color.fromARGB(255, 82, 84, 255),
                    ),
                    child: DropdownButtonFormField<int>(
                      style: MyTheme.whiteTextTheme.headline4,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      items: List.generate(100, (i) => now - i)
                          .map((year) => DropdownMenuItem<int>(
                                child: Text(
                                  year.toString(),
                                ),
                                value: year,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _year = value!;
                        });
                      },
                      value: _year,
                      isExpanded: false,
                      hint: const Text('ปีเกิด'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            StatusChoices(onSelected: _updateStatus),
            const SizedBox(height: 20),
            FamilySizes(onSelected: _updateFamily, formKey: _formKey),
            const SizedBox(height: 20),
            OccuChoices(onSelected: _updateOccu),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 0,
                    fixedSize: const Size(130, 30),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_left,
                        size: 25,
                        color: Color.fromARGB(255, 82, 84, 255),
                      ),
                      Text(
                        'ย้อนกลับ',
                        style: Theme.of(context).textTheme.headline4,
                      )
                    ],
                  ),
                  onPressed: () => AutoRouter.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 0,
                    fixedSize: const Size(130, 30),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'บันทึก',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const Icon(
                        Icons.arrow_right,
                        size: 25,
                        color: Color.fromARGB(255, 82, 84, 255),
                      )
                    ],
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final res = await ref.read(apiProvider).updateUser(
                            _province,
                            _status,
                            _occuType,
                            _family,
                            _year,
                          );
                      if (!res) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('เกิดข้อผิดพลาด')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class StatusChoices extends StatefulWidget {
  const StatusChoices({Key? key, required this.onSelected}) : super(key: key);
  final ValueChanged<String> onSelected;

  @override
  _StatusChoicesState createState() => _StatusChoicesState();
}

class _StatusChoicesState extends State<StatusChoices> {
  String _status = '';
  _updateStatus(String val) {
    widget.onSelected(val);
    setState(() {
      _status = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'สถานะ',
          style: MyTheme.whiteTextTheme.headline3,
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text('โสด', style: MyTheme.whiteTextTheme.headline4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'SIN',
              groupValue: _status,
              onChanged: (value) => _updateStatus(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text(
              'มีคนรักแต่ยังไม่ได้แต่งงาน',
              style: MyTheme.whiteTextTheme.headline4,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'PAR',
              groupValue: _status,
              onChanged: (value) => _updateStatus(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text(
              'แต่งงานแล้ว',
              style: MyTheme.whiteTextTheme.headline4,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'MAR',
              groupValue: _status,
              onChanged: (value) => _updateStatus(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text('หย่าร้าง', style: MyTheme.whiteTextTheme.headline4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'DIV',
              groupValue: _status,
              onChanged: (value) => _updateStatus(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class OccuChoices extends StatefulWidget {
  const OccuChoices({Key? key, required this.onSelected}) : super(key: key);
  final ValueChanged<String> onSelected;

  @override
  _OccuChoicesState createState() => _OccuChoicesState();
}

class _OccuChoicesState extends State<OccuChoices> {
  String _occuType = '';
  _updateOccu(String val) {
    widget.onSelected(val);
    setState(() {
      _occuType = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ลักษณะอาชีพของคุณ',
          style: MyTheme.whiteTextTheme.headline3,
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text(
              'รับราชการ',
              style: MyTheme.whiteTextTheme.headline4,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'GOV',
              groupValue: _occuType,
              onChanged: (value) => _updateOccu(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text(
              'พนักงานบริษัท',
              style: MyTheme.whiteTextTheme.headline4,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'COM',
              groupValue: _occuType,
              onChanged: (value) => _updateOccu(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text(
              'ลูกจ้างรับรายวัน',
              style: MyTheme.whiteTextTheme.headline4,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'DLY',
              groupValue: _occuType,
              onChanged: (value) => _updateOccu(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text('ฟรีแลนซ์', style: MyTheme.whiteTextTheme.headline4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'FRL',
              groupValue: _occuType,
              onChanged: (value) => _updateOccu(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text(
              'ทำธุรกิจส่วนตัว',
              style: MyTheme.whiteTextTheme.headline4,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'BUS',
              groupValue: _occuType,
              onChanged: (value) => _updateOccu(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListTile(
            title: Text(
              'ไม่ได้ทำงาน',
              style: MyTheme.whiteTextTheme.headline4,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: Radio<String>(
              value: 'LES',
              groupValue: _occuType,
              onChanged: (value) => _updateOccu(value!),
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class FamilySizes extends StatefulWidget {
  const FamilySizes({
    Key? key,
    required this.onSelected,
    required this.formKey,
  }) : super(key: key);
  final ValueChanged<int> onSelected;
  final GlobalKey<FormState> formKey;

  @override
  State<FamilySizes> createState() => _FamilySizesState();
}

class _FamilySizesState extends State<FamilySizes> {
  _updateFamily(int val) {
    widget.onSelected(val);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'โปรดใส่จำนวนสมาชิก';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'จำนวนสมาชิกในครัวเรือน',
        labelStyle: MyTheme.whiteTextTheme.headline3,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onSaved: (value) => _updateFamily(int.parse(value!)),
      keyboardType: TextInputType.number,
      style: MyTheme.whiteTextTheme.headline3,
    );
  }
}
