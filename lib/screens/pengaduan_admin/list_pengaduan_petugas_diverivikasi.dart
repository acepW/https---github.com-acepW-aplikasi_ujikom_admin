

import 'package:aplikasi_ujikom_admin/screens/pengaduan_admin/widget/card_aduan.dart';
import 'package:aplikasi_ujikom_admin/screens/pengaduan_admin/widget/detail_aduan_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class ListPengaduanVerifikasiAdmin extends StatefulWidget {
  const ListPengaduanVerifikasiAdmin({super.key});

  @override
  State<ListPengaduanVerifikasiAdmin> createState() =>
      _ListPengaduanVerifikasiAdminState();
}

class _ListPengaduanVerifikasiAdminState
    extends State<ListPengaduanVerifikasiAdmin> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
          centerTitle: true,
          title: Text("Pengaduan Di Verifikasi",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('aduan')
                  .where('status', isEqualTo: 'di verifikasi')
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.length < 1) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Center(
                        child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/empty.png'))),
                                 ),
                      ),
                    );
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        String judul = snapshot.data.docs[index]['judul'];
                        String deskripsi =
                            snapshot.data.docs[index]['deskripsi'];
                        var time =
                            snapshot.data.docs[index]['createdAt'].toDate();
                        String imageUrl = snapshot.data.docs[index]['imageUrl'];
                        String name = snapshot.data.docs[index]['name'];
                        String pengaduId =
                            snapshot.data.docs[index]['pengaduId'];
                        String photoUrl = snapshot.data.docs[index]['photoUrl'];
                        String postId = snapshot.data.docs[index]['postId'];
                        String status = snapshot.data.docs[index]['status'];
                        return CardAduan(judul: judul, deskripsi: deskripsi, onTap: (){
                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailAduanAdmin(
                                        judul: judul,
                                        deskripsi: deskripsi,
                                        postId: postId,
                                        status: status,
                                        imageUrl: imageUrl,
                                        name: name,
                                        tanggal: time)));
                        }, time: time);
                      });
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                );
              },
            )),
      ),
    );
  }
}
