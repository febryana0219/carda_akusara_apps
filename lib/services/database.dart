import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

class DatabaseCarda {
  // Nama database dan versi
  static final String dbName = 'carda.db';
  static final int version = 5;

// Nama tabel
  static final String tableQuiz = 'quiz';
  static final String tableMateri = 'materi';

// Fungsi untuk membuka dan membuat database jika belum ada
  static Future<Database> getDB() async {
    // Mendapatkan path penyimpanan database
    // final directory = await getApplicationDocumentsDirectory();
    // final path = join(directory.path, _dbName);
    final path = join(await getDatabasesPath(), dbName);

    // Membuka database
    return openDatabase(
      path,
      version: version,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableQuiz ( 
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          seqno INTEGER,
          materi_id INTEGER NOT NULL,
          pertanyaan TEXT NOT NULL,
          opsi_a TEXT NOT NULL,
          opsi_b TEXT NOT NULL,
          opsi_c TEXT NOT NULL,
          jawaban TEXT NOT NULL,
          score INTEGER NOT NULL DEFAULT 0,
          live INTEGER NOT NULL DEFAULT 3
        )
      ''');

        await db.execute('''
        CREATE TABLE $tableMateri ( 
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          seqno INTEGER,
          materi_id INTEGER NOT NULL,
          title TEXT,
          title_gambar TEXT,
          aksun TEXT NOT NULL,
          suara TEXT,
          is_completed BOOL NOT NULL DEFAULT false,
          total_score TEXT NOT NULL
        )
      ''');
      },
    );
  }
}
