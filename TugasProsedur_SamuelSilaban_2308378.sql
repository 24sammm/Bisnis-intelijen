CREATE TABLE mahasiswa 
(id_mahasiswa INT PRIMARY KEY, nama_mahasiswa VARCHAR(100) NOT NULL);

CREATE TABLE matakuliah 
(id_matakuliah INT PRIMARY KEY, nama_matakuliah VARCHAR(100) NOT NULL);

CREATE TABLE nilai 
(id_nilai INT PRIMARY KEY AUTO_INCREMENT, id_mahasiswa INT, id_matakuliah INT, nilai INT, 
FOREIGN KEY (id_mahasiswa) REFERENCES Mahasiswa(id_mahasiswa), 
FOREIGN KEY (id_matakuliah) REFERENCES MataKuliah(id_matakuliah));

INSERT INTO mahasiswa (id_mahasiswa, nama_mahasiswa) VALUES 
(1, 'Budi'), (2, 'Siti'), (3, 'Agus');

INSERT INTO matakuliah (id_matakuliah, nama_matakuliah) VALUES 
(1, 'Matematika'), (2, 'Fisika'), (3, 'Kimia');

INSERT INTO nilai (id_mahasiswa, id_matakuliah, nilai) VALUES 
(1, 1, 85), (2, 1, 90), (3, 2, 78);

DELIMITER //

CREATE PROCEDURE tambah_nilai(
    IN p_id_mahasiswa INT,
    IN p_id_matakuliah INT, 
    IN p_nilai INT
)
BEGIN
    INSERT INTO nilai (id_mahasiswa, id_matakuliah, nilai) 
    VALUES (p_id_mahasiswa, p_id_matakuliah, p_nilai);
END;
CALL tambah_nilai(1, 2, 88);
SELECT * FROM nilai;  

CREATE PROCEDURE update_nilai(
    IN p_id_nilai INT,
    IN p_nilai INT
)
BEGIN
UPDATE nilai 
SET nilai = p_nilai
WHERE id_nilai = p_id_nilai;
END;

CALL update_nilai(2, 100);

CREATE PROCEDURE delete_nilai(
    IN p_id_nilai INT
)
BEGIN
DELETE FROM nilai 
WHERE id_nilai = p_id_nilai;
END;

CALL delete_nilai(2);
SELECT * FROM nilai;

DELIMITER //
CREATE FUNCTION hitung_rata_rata(p_id_mahasiswa INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE rata_rata DECIMAL(5,2);
    SELECT AVG(nilai) INTO rata_rata
    FROM nilai
    WHERE id_mahasiswa = p_id_mahasiswa;
    RETURN rata_rata;
END;
DELIMITER ;

SELECT hitung_rata_rata(1);

CREATE FUNCTION get_nama_matakuliah(p_id_matakuliah INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE nama_matakuliah VARCHAR(100);
    SELECT nama_matakuliah INTO nama_matakuliah
    FROM matakuliah
    WHERE id_matakuliah = p_id_matakuliah;
    RETURN COALESCE(nama_matakuliah, 'tidak diketahui');
END;
SELECT get_nama_matakuliah(2);

DELIMITER //
CREATE FUNCTION hitung_jumlah_mahasiswa()
RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE jumlah INT;
    
    SELECT COUNT(*) INTO jumlah FROM mahasiswa;
    
    RETURN jumlah;
END //

DELIMITER ;
SELECT hitung_jumlah_mahasiswa() AS 'Total Mahasiswa';

CREATE PROCEDURE `cek_status_mahasiswa`(
    IN p_id_mahasiswa INT,
    OUT p_status VARCHAR(50)
)
BEGIN
    DECLARE p_nilai_rata DECIMAL(5,2);
    
    SELECT AVG(nilai) INTO p_nilai_rata
    FROM nilai
    WHERE id_mahasiswa = p_id_mahasiswa;
    
    IF p_nilai_rata >= 85 THEN
        SET p_status = 'Sangat Baik';
    ELSEIF p_nilai_rata >= 70 THEN
        SET p_status = 'Baik';
    ELSE
        SET p_status = 'Perlu Peningkatan';
    END IF;
END

CALL cek_status_mahasiswa(3, @status);
SELECT @status

DELIMITER //

CREATE PROCEDURE kategori_mahasiswa(
    IN p_id_mahasiswa INT,
    OUT p_kategori VARCHAR(50)
)
BEGIN
    DECLARE p_nilai_rata DECIMAL(5,2);
    
    SELECT AVG(nilai) INTO p_nilai_rata
    FROM nilai
    WHERE id_mahasiswa = p_id_mahasiswa;
    
    SET p_kategori = CASE
        WHEN p_nilai_rata >= 85 THEN 'Sangat Baik'
        WHEN p_nilai_rata >= 70 THEN 'Baik'
        ELSE 'Perlu Peningkatan'
    END;
END //

DELIMITER ;

CALL kategori_mahasiswa(1, @kategori);
SELECT @kategori

DELIMITER //

CREATE PROCEDURE OR REPLACE hitung_total_nilai(
    IN p_id_mahasiswa INT,
    OUT p_total_nilai INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nilai_baru INT;
    DECLARE cur CURSOR FOR SELECT nilai FROM nilai WHERE id_mahasiswa = p_id_mahasiswa;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET p_total_nilai = 0;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO nilai;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET p_total_nilai = p_total_nilai + nilai;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;
DROP PROCEDURE IF EXISTS hitung_total_nilai;

CALL hitung_total_nilai(2, @total_nilai);
SELECT @total_nilai AS total_nilai;

CREATE TABLE log_nilai (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_mahasiswa INT,
    id_matakuliah INT,
    nilai INT,
    waktu TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER after_insert_nilai
AFTER INSERT ON nilai
FOR EACH ROW
BEGIN
    INSERT INTO log_nilai (id_mahasiswa, id_matakuliah, nilai)
    VALUES (NEW.id_mahasiswa, NEW.id_matakuliah, NEW.nilai);
END;
INSERT INTO nilai (id_mahasiswa, id_matakuliah, nilai) VALUES (2, 3, 120);
SELECT * FROM nilai;
SELECT * FROM log_nilai;

CREATE TRIGGER before_insert_nilai
BEFORE INSERT ON nilai
FOR EACH ROW
BEGIN
    IF NEW.nilai < 0 OR NEW.nilai > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nilai harus antara 0 dan 100';
    END IF;
END;
INSERT INTO nilai (id_mahasiswa, id_matakuliah, nilai) VALUES (1, 3, 85);
SELECT * FROM nilai;
SELECT * FROM log_nilai;

ALTER TABLE mahasiswa ADD rata_rata DECIMAL(5,2);

CREATE TRIGGER before_update_nilai
BEFORE UPDATE ON nilai
FOR EACH ROW
BEGIN
DECLARE rata_rata DECIMAL(5,2);
SELECT AVG(nilai) INTO rata_rata
FROM nilai
WHERE id_mahasiswa = NEW.id_mahasiswa;

UPDATE mahasiswa
SET rata_rata = rata_rata
WHERE id_mahasiswa = NEW.id_mahasiswa;
END;

UPDATE nilai SET nilai = 90 WHERE id_nilai = 1;
SELECT * FROM mahasiswa;
SELECT * FROM nilai;

--------TUGAS LATIHAN PROSEDUR DAN TRIGGER--------

---tugas latihan prosedur1---
DELIMITER //

CREATE PROCEDURE cek_kelulusan(
    IN p_id_mahasiswa INT,
    OUT p_status VARCHAR(100)
)
BEGIN
    DECLARE rata_rata DECIMAL(5,2);

    SELECT AVG(nilai) INTO rata_rata
    FROM nilai
    WHERE id_mahasiswa = p_id_mahasiswa;

    IF rata_rata >= 75 THEN
        SET p_status = 'Lulus';
    ELSE
        SET p_status = 'Tidak Lulus';
    END IF;
END //

DELIMITER ;

CALL cek_kelulusan(1, @status);
SELECT @status;

---Tugas prosedur 2----
DELIMITER //

CREATE PROCEDURE total_nilai_semua_mahasiswa(
    OUT p_total_nilai INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nilai_individual INT;
    DECLARE cur CURSOR FOR SELECT nilai FROM nilai;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET p_total_nilai = 0;
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO nilai_individual;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET p_total_nilai = p_total_nilai + nilai_individual;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL total_nilai_semua_mahasiswa(@total);
SELECT @total;

---Tugas prosedur 3----
DELIMITER //

CREATE PROCEDURE cari_nama_matakuliah(
    IN p_id_matakuliah INT,
    OUT p_nama_matakuliah VARCHAR(100)
)
BEGIN
    DECLARE v_nama VARCHAR(100);

    SELECT nama_matakuliah INTO v_nama
    FROM matakuliah
    WHERE id_matakuliah = p_id_matakuliah;

    IF v_nama IS NOT NULL THEN
        SET p_nama_matakuliah = v_nama;
    ELSE
        SET p_nama_matakuliah = 'Mata kuliah tidak ditemukan';
    END IF;
END //

DELIMITER ;

CALL cari_nama_matakuliah(1, @nama);
SELECT @nama;

---Latihan trigger 1---
DELIMITER //

CREATE TRIGGER before_delete_nilai
BEFORE DELETE ON nilai
FOR EACH ROW
BEGIN
    IF OLD.nilai < 50 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tidak dapat menghapus nilai di bawah 50';
    END IF;
END //

DELIMITER ;
---Latihan trigger 2---
DELIMITER //

CREATE TRIGGER after_delete_nilai
AFTER DELETE ON nilai
FOR EACH ROW
BEGIN
    INSERT INTO log_nilai (id_mahasiswa, id_matakuliah, nilai)
    VALUES (OLD.id_mahasiswa, OLD.id_matakuliah, OLD.nilai);
END //

DELIMITER ;

ALTER TABLE mahasiswa ADD total_nilai INT DEFAULT 0;
DELIMITER //
---Latihan trigger 3---
CREATE TRIGGER before_update_nilai_total
BEFORE UPDATE ON nilai
FOR EACH ROW
BEGIN
    DECLARE total INT;

    SELECT COALESCE(SUM(nilai), 0) INTO total
    FROM nilai
    WHERE id_mahasiswa = NEW.id_mahasiswa;

    SET total = total - OLD.nilai + NEW.nilai;

    UPDATE mahasiswa
    SET total_nilai = total
    WHERE id_mahasiswa = NEW.id_mahasiswa;
END //

DELIMITER ;
