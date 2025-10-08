CREATE TABLE anggota (
    id_anggota INT(3) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nim_anggota VARCHAR(32) NOT NULL,
    alamat TEXT NOT NULL,
    ttl_anggota TEXT NOT NULL,
    status_anggota VARCHAR(1) NOT NULL
);

INSERT INTO anggota (nim_anggota, alamat, ttl_anggota, status_anggota)
VALUES
('2308378', 'Garut', 'Garut, 2005-09-24', 'Y'),
('2308948', 'Jakarta', 'Jakarta, 2000-02-22', 'Y'),
('2304565', 'Surabaya', 'Surabaya, 2000-03-10', 'Y'),
('2304535', 'Medan', 'Medan, 2000-04-18', 'Y'),
('2309493', 'Yogyakarta', 'Yogyakarta, 2000-05-05', 'Y'),
('2302334', 'Palembang', 'Palembang, 2000-06-30', 'Y'),
('2309859', 'Semarang', 'Semarang, 2000-07-15', 'Y'),
('2302312', 'Denpasar', 'Denpasar, 2000-08-25', 'Y'),
('2305478', 'Makassar', 'Makassar, 2000-09-12', 'Y'),
('2308345', 'Padang', 'Padang, 2000-10-01', 'Y');


SELECT * FROM anggota

CREATE TABLE buku (
    kd_buku INT(5) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    judul_buku VARCHAR(32) NOT NULL,
    pengarang VARCHAR(32) NOT NULL,
    jenis_buuku VARCHAR(32) NOT NULL,
    penerbit VARCHAR(32) NOT NULL
);

INSERT INTO buku (judul_buku, pengarang, jenis_buuku, penerbit)
VALUES
('Belajar SQL', 'Andi Setiawan', 'Teknologi', 'Gramedia'),
('Pemrograman Web', 'Rina Hartati', 'Teknologi', 'Informatika'),
('Biologi Laut', 'Samuel Silaban', 'Sains', 'Ocean Press'),
('Fisika Dasar', 'Dedi Suhendra', 'Sains', 'Cerdas Publisher'),
('Matematika Lanjut', 'Sinta Dewi', 'Pendidikan', 'Eduka'),
('Bahasa Inggris', 'John Smith', 'Bahasa', 'Oxford'),
('Algoritma Pemrograman', 'Budi Santoso', 'Teknologi', 'Erlangga'),
('Ekologi Laut', 'Ahmad Fauzi', 'Sains', 'Maritim'),
('Pengantar AI', 'Lisa Adelia', 'Teknologi', 'Informatika'),
('Sistem Informasi', 'Slamet Riyadi', 'Teknologi', 'Andi Publisher');


SELECT * FROM buku

CREATE TABLE meminjam (
    id_pinjam INT(3) PRIMARY KEY NOT NULL AUTO_INCREMENT,
    tgl_pinjam DATE NOT NULL,
    jumlah_pinjam INT(2),
    tgl_kembali DATE NOT NULL,
    anggota_id INT(3) NOT NULL,
    kode_buku INT(5) NOT NULL,
    kembali INT(1) NOT NULL,
    CONSTRAINT fk_anggota FOREIGN KEY (anggota_id) REFERENCES anggota(id_anggota),
    CONSTRAINT fk_buku FOREIGN KEY(kode_buku) REFERENCES buku(kd_buku)
);

INSERT INTO meminjam (tgl_pinjam, jumlah_pinjam, tgl_kembali, anggota_id, kode_buku, kembali)
VALUES
  ('2025-09-10', 2, '2025-09-17', 1, 1, 1),
  ('2025-09-10', 1, '2025-09-17', 1, 2, 1),
  ('2025-09-25', 1, '2025-10-02', 2, 3, 0),
  ('2025-08-15', 1, '2025-08-22', 3, 4, 1),
  ('2025-08-16', 1, '2025-08-23', 3, 5, 1),
  ('2025-08-17', 1, '2025-08-24', 3, 6, 1),
  ('2025-08-18', 1, '2025-08-25', 3, 7, 1),
  (CURDATE(),  1, DATE_ADD(CURDATE(), INTERVAL 7 DAY), 4, 8, 0),
  ('2025-09-29', 1, '2025-10-05', 5, 9, 0),
  ('2025-08-01', 1, '2025-08-08', 6, 10, 1),
  (CURDATE(),  1, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 7, 1, 0);


SELECT * FROM meminjam

--Menampilkan data anggota yang belum pernah meminjam buku
SELECT a.*
FROM anggota a
LEFT JOIN meminjam m ON a.id_anggota = m.anggota_id
WHERE m.anggota_id IS NULL;


--menampilkan seluruh anggota yang meminjam buku hari ini
SELECT DISTINCT a.*
FROM anggota a
JOIN meminjam m ON a.id_anggota = m.anggota_id
WHERE m.tgl_pinjam = CURDATE();

--Menampilkan data yang pernah meminjam buku lebih dari 3 buku
SELECT a.id_anggota, a.nim_anggota, a.alamat, a.ttl_anggota, COUNT(m.id_pinjam) AS total_pinjam
FROM anggota a
JOIN meminjam m ON a.id_anggota = m.anggota_id
GROUP BY a.id_anggota, a.nim_anggota, a.alamat, a.ttl_anggota
HAVING COUNT(m.id_pinjam) > 3;

--Menampilkan data buku yang belum kembali setelah deadline tanggal kembali
SELECT b.kd_buku, b.judul_buku, b.pengarang, b.jenis_buuku, b.penerbit,
       a.nim_anggota, m.tgl_pinjam, m.tgl_kembali
FROM buku b
JOIN meminjam m ON b.kd_buku = m.kode_buku
JOIN anggota a ON a.id_anggota = m.anggota_id
WHERE m.kembali = 0
  AND m.tgl_kembali < CURDATE();

--Mengubah status keanggotaan menjadi tidak aktif (N) bagi anggota yang belum pernah meminjam buku
UPDATE anggota
SET status_anggota = 'N'
WHERE id_anggota NOT IN (
    SELECT DISTINCT anggota_id FROM meminjam
);

SELECT * FROM anggota;
SELECT * FROM buku;
SELECT * FROM meminjam;