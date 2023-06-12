delimiter <>
create or replace trigger register 
before insert on pengguna for each row
begin
declare cekUsername int;
declare cekNoTelp int;
declare cekEmail int;
set cekUsername=(select username from pengguna where username= new.username);
set cekNoTelp=(select noTelp from pengguna where noTelp= new.noTelp);
set cekEmail=(select email from pengguna where email=new.Email);
if (cekNoTelp is null and new.noTelp is not null) then
	if(cekUsername is null) then
		if(char_length(new.password)<8) then
			signal sqlstate '44444'
			set message_text = 'Password minimal 8 digit!!';
		else
			set new.id = uuid();
			set new.password=password(new.password);
			set new.level=1;
		end if;
	else
		signal sqlstate '44444'
		set message_text = 'Username telah diambil, silahkan ganti yang lain';
	end if;
elseif(cekEmail is null and new.email is not null) then
	if(cekUsername is null) then
		if(char_length(new.password)<8) then
			signal sqlstate '44444'
			set message_text = 'Password minimal 8 digit!!';
		else
			set new.id = uuid();
			set new.password=password(new.password);
			set new.level=1;
		end if;
	else
		signal sqlstate '44444'
		set message_text = 'Username telah diambil, silahkan ganti yang lain';
	end if;
else
	signal sqlstate '44444'
	set message_text = 'Nomor telepon atau email sudah terdaftar';
end if;
end <>
delimiter ;
select*from pengguna;
INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`, `email`, `password`, `pin`) VALUES 
('Ilham', 'ilhamz','08129022310', 'ilham@gmail.com', 'ilham7580', '7580');

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `email`, `password`) VALUES 
('Ilham', 'gogo', 'ilham@gmail.com', 'ilham7580');-- email sama

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`, `password`) VALUES 
('Ilham', 'alhim','08129022310', 'ilham7580');-- no telepon sama

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `noTelp`, `password`) VALUES 
('Laura', '085367818912', 'laura12');-- password <8 digit

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`,`email`, `password`) VALUES 
('Laura', 'ilhamz','085367818912', 'Laura22@gmail.com','laura123'); -- email, no telp baru tpi username sama

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`,`email`, `password`) VALUES 
('Laura', 'lauraz','085367818912', 'Laura22@gmail.com','laura123'); 

INSERT INTO `shop`.`pengguna` (`namaLengkap`, `username`, `noTelp`,`email`, `password`, `pin`) VALUES 
('Budi', 'budiz','0846635353553', 'budi343@gmail.com','budi6565','6565');
select*from pengguna;


delimiter <>
create trigger addKategori
before insert on kategori for each row
begin
declare cekKategori int;
set cekKategori=(select nama from kategori where nama=new.nama);
if(cekKategori is not null) then
	signal sqlstate '44444'
	set message_text = 'Kategori sudah ada!!';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Elektronik');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Fashion');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Elektronik');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Perfume');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Accesories');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('fashion');
INSERT INTO `shop`.`kategori` (`nama`) VALUES ('Alat Dapur');
select*from kategori;

delimiter <>
create or replace trigger addPelapak
before insert on pelapak for each row
begin
declare cekPelapak int;
set cekPelapak=(select nama from pelapak where nama=new.nama and lokasi=new.lokasi);
if(cekPelapak is not null) then
	signal sqlstate '44444'
	set message_text = 'Pelapak sudah ada, tidak bisa menambah data';
end if;
set new.id = uuid();
end <>
delimiter ;
select*from pelapak;
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Asus Official', 'Jakarta', 'positif', 2, 5);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Zara', 'Bandung', 'positif', 1, 3);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Asus Official', 'Jakarta', 'positif', 4, 6);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Indonesia Merk', 'Jakarta', 'positif', 3, 5);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Xyz Shop', 'Bandung', 'positif', 20, 24);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('H&M', 'Jakarta', 'positif', 1, 2);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Gucci', 'Kalimantan', 'positif', 1, 3);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Sonny Official', 'Jakarta', 'positif', 2, 4);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Samsung Official', 'Jakarta', 'negatif', 1, 3);
INSERT INTO `shop`.`pelapak` (`nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) VALUES 
('Samsung Official', 'Jakarta', 'negatif', 1, 6);
select*from pelapak;

delimiter <>
create trigger addDompetDigital
before insert on dompetdigital for each row
begin
declare cekDompetDigital int;
set cekDompetDigital=(select nama from dompetdigital where nama=new.nama);
if(cekDompetDigital is not null) then
	signal sqlstate '44444'
	set message_text = 'Dompet digital sudah ada, tidak dapat menambah data';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('OVO');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('OVO');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('BCA');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('GoPay');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('ShopeePay');
INSERT INTO `shop`.`dompetDigital` (`nama`) VALUES ('DANA');
select*from dompetdigital;

delimiter <>
create or replace trigger addPromo
before insert on promo for each row
begin
declare cekPromo int;
set cekPromo=(select nama from promo where nama=new.nama and minTransaksi=new.minTransaksi);
if(cekPromo is not null) then
	signal sqlstate '44444'
	set message_text = 'Promo sudah ada, tidak dapat menambah data';
end if;
set new.id = uuid();
end <>
delimiter ;

INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Lebaran', 'Diskon 20% untuk semua produk', 100000, 1);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Natal', 'Diskon 10% untuk semua produk', 200000, 2);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Lebaran', 'Diskon 30% untuk semua produk', 100000, 1);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Lebaran', 'Diskon 30% untuk semua produk', 150000, 1);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo 6.6', 'Diskon 20% untuk semua produk', 400000, 3);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Potongan', 'Diskon 10% Potongan Untuk Produk Yang Dpilih', 0, 1);
INSERT INTO `shop`.`promo` (`nama`, `deskripsi`, `minTransaksi`, `levelPengguna`) VALUES 
('Promo Tahun Baru', 'Diskon 40% untuk semua produk', 200000, 3);
select*from promo;