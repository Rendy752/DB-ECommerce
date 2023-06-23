delimiter <>
create or replace procedure validasiLoginViaNoTelp(varNoTelp varchar(255),varPassword varchar(255))
begin
declare cekNoTelp int;
declare cekPassword int;
set cekNoTelp=(select noTelp from pengguna where noTelp= varNoTelp);
set cekPassword=(select password from pengguna where noTelp=varNoTelp and password=password(varPassword));
if(cekNoTelp is null) then
	signal sqlstate '44444'
	set message_text = 'Nomor telepon yang diinput belum terdaftar';-- lewat dari if ini berarti no telp pasti terdaftar
else 
	if(cekPassword is null) then
		signal sqlstate '44444'
		set message_text = 'Password yang diinput salah';
	else
		select 'Login Berhasil' as Notifikasi,now() as Waktu;
	end if;
end if;
end <>
delimiter ;

call validasiLoginViaNoTelp('99999999999','ilham7580'); -- nomor telepon tidak terdaftar
call validasiLoginViaNoTelp('08129022310','hhhhhhhhh'); -- salah password
call validasiLoginViaNoTelp('08129022310','ilham7580');

delimiter <>
create or replace procedure validasiLoginViaEmail(varEmail varchar(255),varPassword varchar(255))
begin
declare cekEmail int;
declare cekPassword int;
set cekEmail=(select email from pengguna where email=varEmail);
set cekPassword=(select password from pengguna where email=varEmail and password=password(varPassword));
if(cekEmail is null) then
	signal sqlstate '44444'
	set message_text = 'Email yang diinput belum terdaftar';-- lewat dari if ini berarti email pasti terdaftar
else 
	if(cekPassword is null) then
		signal sqlstate '44444'
		set message_text = 'Password yang diinput salah';
	else
		select 'Login Berhasil' as Notifikasi,now() as Waktu;
	end if;
end if;
end <>
delimiter ;

call validasiLoginViaEmail('hhhhh@gmail.com','ilham7580'); -- email belum terdaftar
call validasiLoginViaEmail('ilham@gmail.com','hhhhhhhhh'); -- password salah
call validasiLoginViaEmail('ilham@gmail.com','ilham7580');

delimiter <>
create or replace procedure sebarPromo()
begin
declare i int default 0;
declare j int default 0;
declare jumlahPengguna int;
declare jumlahPromo int;
declare cekLevel int;
declare cekPromoDuplikat int;
declare varIdPengguna char(36);
declare varIdPromo char(36);
set jumlahPengguna=(select count(id) from pengguna);
set jumlahPromo=(select count(id) from promo);
if (jumlahPromo=0) then
	signal sqlstate '44444'
	set message_text = 'Tidak ada promo';
elseif (jumlahPengguna=0) then
	signal sqlstate '44444'
	set message_text = 'Tidak ada pengguna';
else
	while (i<jumlahPengguna) do
		set cekLevel=(select level from pengguna limit i,1);
		set varIdPengguna=(select id from pengguna limit i,1);
        set j=0; -- reset j
        while(j<jumlahPromo) do
			if(cekLevel>=(select levelPengguna from promo limit j,1)) then -- level pengguna telah memenuhi syarat untuk diberi promo
				set varIdPromo=(select id from promo limit j,1);
				set cekPromoDuplikat=(select count(idPengguna) from promoTerhubung where idPengguna=varIdPengguna and idPromo=varIdPromo);
				if(cekPromoDuplikat=0) then -- memastikan tiap pengguna tidak mendapat promo yang sama
					insert into promoTerhubung (idPengguna,idPromo) values (varIdPengguna,varIdPromo);
				end if;
			end if;
		set j=j+1;
		end while;
	set i=i+1;
    end while;
end if;
end <>
delimiter ;
call sebarPromo();

delimiter <>
create or replace procedure lihatPromoPengguna(varUsername varchar(255))
begin
	declare varIdPengguna char(36);
    set varIdPengguna=(select id from pengguna where username=varUsername);
	if(varIdPengguna is null) then
		signal sqlstate '44444'
		set message_text = 'Username belum terdaftar!';
	else
		if((select count(*) from promoTerhubung where idPengguna=varIdPengguna)=0) then
			signal sqlstate '44444'
			set message_text = 'Pengguna terkait belum mendaftarkan alamat!';
		else
			select pr.nama as `Nama Promo`, pr.deskripsi `Deskripsi`, pr.minTransaksi as `Minimal Transaksi`
			from promoTerhubung pt join pengguna pe join promo pr where pe.id = pt.idPengguna and pr.id = pt.idPromo and pe.username=varUsername;
		end if;
	end if;
end <>
delimiter ;

call lihatPromoPengguna('budiz');
call lihatPromoPengguna('lauraz');
call lihatPromoPengguna('ilhamz');
call lihatPromoPengguna('santoso'); -- username belum terdaftar
call lihatPromoPengguna('liliaz');

delimiter <>
create or replace procedure pesan(varUsername varchar(255),varPromo varchar(255),varAlamat varchar(255),
					   varMetodePembayaran varchar(255),varTanggal date,listProduk varchar(255),
                       listJumlah varchar(255),listKurir varchar(255),listPromoPelapak varchar(255),varCatatan text)
begin
declare varIdPengguna char(36);
declare varIdPromo char(36);
declare varIdAlamat char(36);
declare varIdMetodePembayaran char(36);
declare varIdProduk char(36);
declare varIdPelapak char(36);
declare varIdKurir char(36);
declare varIdPromoPelapak char(36);
declare warning varchar(255);
declare cekKoma int default 1;
declare i int default 1;
declare j int default 1;
declare varProduk varchar(255);
declare varJumlah varchar(255);
declare varKurir varchar(255);
declare varPromoPelapak varchar(255);
declare cekStok int;
declare varHarga decimal(10,2);
declare varMinTransaksi decimal(10,2);
declare varUUIDPesanan char(36);
declare varUUIDPelapak char(36);
declare cekUUID int default 0;
declare jumlahPromoValid int default 0;
set varUUIDPesanan=uuid();
set varIdPengguna=(select id from pengguna where username=varUsername);
set varIdPromo=(select id from promo join promoTerhubung where promo.id=promoTerhubung.idPromo 
				and idPengguna=varIdPengguna and promo.nama=varPromo);
set varIdAlamat=(select id from alamat where idPengguna=varIdPengguna and alamat=varAlamat);
set varIdMetodePembayaran=(select id from metodePembayaran join metodePembayaranTerhubung 
						  where metodePembayaran.id=metodePembayaranTerhubung.idMetodePembayaran and idPengguna=varIdPengguna 
						  and metodePembayaran.nama=varMetodePembayaran);
if(varIdPengguna is null) then
	set warning= concat("Username pengguna '",varUsername, "' tidak diketahui");
	signal sqlstate '44444' set message_text = warning;
elseif(varIdAlamat is null) then
	set warning= concat("Username pengguna '",varUsername, "' tidak memiliki alamat '",varAlamat,"'");
	signal sqlstate '44444' set message_text = warning;
elseif(varIdMetodePembayaran is null) then
	set warning= concat("Username pengguna '",varUsername, "' tidak memiliki metode pembayaran '",varMetodePembayaran,"'");
	signal sqlstate '44444' set message_text = warning;
end if;
create table if not exists Pemberitahuan (pemberitahuan varchar(255));
create table if not exists PromoPelapakSementara (idPesananPelapak char(36),idPromoPelapak char(36));
while(cekKoma!=0) do
-- select cekKoma;
	set cekKoma=(select locate(',',listProduk,cekKoma+1)); -- cekKoma default 1
    set varProduk=(select substring_index(substring_index(listProduk, ',', i), ',', -1));
    set varIdProduk=(select id from produk where nama=varProduk);
    set varJumlah=(select substring_index(substring_index(listJumlah, ',', i), ',', -1));
	set cekStok=(select stok from produk where id=varIdProduk);
-- select cekKoma, varProduk,varIdProduk,i;
	if(varIdProduk is not null) then
        if(varJumlah<=cekStok) then
			set cekUUID=1; -- memastikan paling tidak ada 1 produk yang valid untuk dibuat pesanan
            if((select id from pesanan where id=varUUIDPesanan) is null) then -- membatasi pesanan dibuat hanya 1x
				insert into pesanan(id,idPengguna,idAlamat,idMetodePembayaran,tanggal) values
				(varUUIDPesanan,varIdPengguna,varIdAlamat,varIdMetodePembayaran,varTanggal);
			end if;
            set varIdPelapak=(select idPelapak from produk where id=varIdProduk);
            if((select pesananPelapak.id from pesanan join pesananPelapak on pesanan.id=pesananPelapak.idPesanan 
            where pesanan.id=varUUIDPesanan and pesananPelapak.idPelapak=varIdPelapak) is null) then -- membatasi sebuah pesanan tidak memiliki pelapak ganda
				set varUUIDPelapak=uuid();
				set varKurir=(select substring_index(substring_index(listKurir, ',', j), ',', -1));
                set varIdKurir=(select id from kurir where nama=varKurir);
                if(varIdKurir is not null) then
					insert into pesananPelapak(id,idPesanan,idPelapak,idKurir,status,catatan) 
					values (varUUIDPelapak,varUUIDPesanan,varIdPelapak,varIdKurir,'Sedang diproses',varCatatan);
                else
					insert into Pemberitahuan values (concat('Kurir = ', varKurir,' tidak diketahui, set default ke kurir BukaExpress REG'));
					insert into pesananPelapak(id,idPesanan,idPelapak,idKurir,status,catatan) 
					values (varUUIDPelapak,varUUIDPesanan,varIdPelapak,(select id from kurir where nama='BukaExpress REG'),'Sedang diproses',varCatatan);
                end if;
                set varPromoPelapak=(select substring_index(substring_index(listPromoPelapak, ',', j), ',', -1));
                set varIdPromoPelapak=(select id from promoPelapak where idPelapak=varIdPelapak and nama=varPromoPelapak);
                if(varIdPromoPelapak is not null) then
					insert into PromoPelapakSementara values (varUUIDPelapak,varIDPromoPelapak);
				end if;
                set j=j+1;
            end if;
			insert into detailPesanan(idPesananPelapak,idProduk,jumlah) values (varUUIDPelapak,varIdProduk,varJumlah);
			update produk set stok=stok-varJumlah,terjual=terjual+varJumlah where id=varIdProduk;
		else
			insert into Pemberitahuan values (concat('Stok ',varProduk,' tidak mencukupi'));
		end if;
	else
		insert into Pemberitahuan values (concat(varProduk,' tidak diketahui'));
	end if;
    set i=i+1;
end while;
while(jumlahPromoValid<(select count(*) from PromoPelapakSementara)) do
	set varUUIDPelapak=(select idPesananPelapak from PromoPelapakSementara limit jumlahPromoValid,1);
	set varHarga=(select sum(produk.harga*detailPesanan.jumlah) from pesananPelapak left join detailPesanan 
				on pesananPelapak.id=detailPesanan.idPesananPelapak join produk on detailPesanan.idProduk=produk.id 
                where pesananPelapak.id=varUUIDPelapak);
	set varIdPromoPelapak=(select idPromoPelapak from PromoPelapakSementara limit jumlahPromoValid,1);
    select*from promopelapaksementara;
    select varUUIDPelapak,varIdPromoPelapak;
	set varMinTransaksi=(select minTransaksi from promoPelapak where id=varIdPromoPelapak);
	if(varHarga>=varMinTransaksi) then
		update pesananPelapak set idPromoPelapak=varIdPromoPelapak where id=varUUIDPelapak;
	else
		insert into Pemberitahuan values (concat('Total harga pesanan pada salah satu pelapak = ', varHarga, '> kriteria min transaksi ', varPromoPelapak, '= ',varMinTransaksi));
	end if;
set jumlahPromoValid=jumlahPromoValid+1;
end while;
set varMinTransaksi=(select minTransaksi from promo where id=varIdPromo);
if(cekUUID=1) then -- jika terdapat pesanan barang yang valid
	if(varIdPromo is not null) then
		if(varHarga>=varMinTransaksi) then
			update pesanan set idPromo=varIdPromo where id=varUUIDPesanan;
			delete from promoTerhubung where idPengguna=varIdPengguna and idPromo=varIdPromo;
		else
			insert into Pemberitahuan values (concat('Total harga pesanan = ', varHarga, '> kriteria min transaksi ', varPromo, '= ',varMinTransaksi));
		end if;
	end if;
end if;
select*from Pemberitahuan;
drop table if exists Pemberitahuan;
drop table if exists PromoPelapakSementara;
end <>
delimiter ;
SELECT*FROM metodepembayaranterhubung;
select*from pelapak;
select*from promopelapak;
select*from produk;
select*from pesanan;
select*from pesananPelapak;
select*from detailpesanan;
select*from kurir;

select*from lihatSemuaPesanan;
call pesan('hafiz','','Jl. Siput No. 123','OVO','2023-06-07','Headphone Sony',1,'SiCepat HALU','Promo',''); -- username tidak diketahui
call pesan('ilhamz','','Jl. Siput No. 123','OVO','2023-06-07','Headphone Sony',1,'SiCepat REG','Promo',''); -- alamat tidak deketahui pada pengguna terkait
call pesan('ilhamz','','Jl. Rambutan No. 123','GoPay','2023-06-07','Headphone Sony',1,'BukaExpress REG','Promo',''); -- metode pembayaran tidak diketahui pada pengguna terkait
call pesan('ilhamz','','Jl. Rambutan No. 123','OVO','2023-06-07','Headphone Asus',1,'J&t REG','Promo Lebaran',''); -- produk tidak diketahui
call pesan('ilhamz','','Jl. Rambutan No. 123','OVO','2023-06-07','Headphone Sony',1,'J&t REG','Promo Lebaran','Cepat kirim');
call pesan('budiz','Promo lebaran','Jl. Mangga No. 456','Gopay','2023-06-07','Headphone Sony',1,'J&t REG','Potongan harga','Cepat kirim'); -- 
call pesan('ilhamz','Promo Lebaran','Jl. Rambutan No. 123','OVO','2023-06-07','Headphone Sony',2,'J&t','Potongan harga','Cepat kirim');
call pesan('ilhamz','Promo Lebaran','Jl. Rambutan No. 123','OVO','2023-06-07','Kemeja Denim',3,'SiCepat REG','Potongan harga','');
call pesan('budiz','Promo Lebaranz','Jl. Mangga No. 456','BCA','2023-06-08','Laptop Asus ZenForce',1,'J&t','Potongan harga','');
call pesan('budiz','Promo Lebaran','Jl. Mangga No. 456','GoPay','2023-06-08','Sepatu Nike Running,Kemeja Denim','1, 2','SiCepat HALU,J&T REG','Potongan harga,Potongan harga','');
call pesan('budiz','Promo Lebaran','Jl. Mangga No. 456','GoPay','2023-06-09',
'Headphone Sony,Kemeja Denim,Laptop Asus ZenForce,Carolina Herera,Sepatu Nike Running,Baju Renang',
'2,4,1,3,30,2','SiCepat HALU,J&T REG,BukaExpress REG,J&T REG','Potongan harga,Potongan harga,Promo Lebaran,Potongan harga','');

delimiter <>
create or replace procedure lihatNotaPesanan(varIdPesananPelapak char(36))
begin
declare cekPesananPelapak char(36);
set cekPesananPelapak=(select id from pesananPelapak where id=varIdPesananPelapak);
if(cekPesananPelapak is null) then
	signal sqlstate '44444' set message_text = 'Pesanan pelapak tidak diketahui';
else
select pesananPelapak.id as `No. Pesanan`,round(coalesce(sum(detailPesanan.jumlah*produk.harga)+sum(kurir.ongkir)-
coalesce(sum((detailPesanan.jumlah*produk.harga))*(promoPelapak.diskon/100),0),sum(detailPesanan.jumlah*produk.harga)+
sum(kurir.ongkir)),2) as `Total Pembayaran`, pesanan.tanggal as `Tanggal Pemesanan`,alamat.namaPenerima as `Nama Penerima`,
pelapak.nama as `Pelapak`,sum(detailPesanan.jumlah*produk.harga) as `Subtotal Belanja`,sum(kurir.ongkir) as `Ongkir`,
sum(detailPesanan.jumlah*produk.harga)+sum(kurir.ongkir) as `Subtotal`,concat('Rp',round(substring_index(coalesce
(sum((detailPesanan.jumlah*produk.harga))*(promoPelapak.diskon/100),0),'.',2),2)) as `Potongan Harga Barang`,
round(coalesce(sum(detailPesanan.jumlah*produk.harga)+sum(kurir.ongkir)-coalesce(sum((detailPesanan.jumlah*produk.harga))*
(promoPelapak.diskon/100),0),sum(detailPesanan.jumlah*produk.harga)+sum(kurir.ongkir)),2) as `Total Belanja`,
concat(alamat,', ',kecamatan,', ',kota,'. ',provinsi,', ',kodePos,'.') as `Alamat`, metodePembayaran.nama as `Metode Pembayaran`
from promoPelapak right join pesananPelapak on promoPelapak.id=pesananPelapak.idPromoPelapak 
join pesanan on pesananPelapak.idPesanan=pesanan.id join detailPesanan on detailPesanan.idPesananPelapak=pesananPelapak.id 
join pelapak on pesananPelapak.idPelapak=pelapak.id join produk on detailPesanan.idProduk=produk.id join pengguna 
on pesanan.idPengguna=pengguna.id join kurir on kurir.id=pesananPelapak.idKurir join alamat on pesanan.idAlamat=alamat.id 
join metodePembayaran on metodePembayaran.id=pesanan.idMetodePembayaran where pesananPelapak.id=varIdPesananPelapak;
end if;
end <>
delimiter ;

select*from pesananPelapak;
call lihatNotaPesanan('ea824d73-1042-11ee-b1a1-6802ce07b577');
call lihatNotaPesanan('ef89a9d0-103c-11ee-b1a1-6802ce07b577');
call lihatNotaPesanan('9ce65cd8-103a-11ee-b1a1-6802ce07b577');
call lihatNotaPesanan('41ed9c7c-103b-11ee-b1a1-6802ce07b577');
call lihatNotaPesanan('797eefa8-1042-11ee-b1a1-6802ce07b577');
call lihatNotaPesanan('b9ee6e6e-103b-11ee-b1a1-6802ce07b577');

delimiter <>
create or replace procedure cariProduk(varNama varchar(255))
begin
drop table if exists CariProduk;
-- Relevansi
create table if not exists CariProduk (`No(Relevansi)` int auto_increment primary key,Nama varchar(255),Harga decimal(10,2),Rating double,Terjual int,Lokasi varchar(20));
insert into CariProduk (Nama,Harga,Rating,Terjual,Lokasi) select 
produk.nama,produk.harga,produk.rating,produk.terjual,pelapak.lokasi 
from produk,pelapak where produk.idPelapak=pelapak.id and produk.nama like concat('%',varNama,'%');
select*from CariProduk;
-- Terbaru
truncate CariProduk;alter table CariProduk change column `No(Relevansi)` `No(Terbaru)` int auto_increment;
insert into CariProduk (Nama,Harga,Rating,Terjual,Lokasi) select 
produk.nama,produk.harga,produk.rating,produk.terjual,pelapak.lokasi 
from produk,pelapak where produk.idPelapak=pelapak.id and produk.nama like concat('%',varNama,'%') order by produk.createdAt desc;
select*from CariProduk;
-- Terlaris
truncate CariProduk;alter table CariProduk change column `No(Terbaru)` `No(Terlaris)` int auto_increment;
insert into CariProduk (Nama,Harga,Rating,Terjual,Lokasi) select 
produk.nama,produk.harga,produk.rating,produk.terjual,pelapak.lokasi 
from produk,pelapak where produk.idPelapak=pelapak.id and produk.nama like concat('%',varNama,'%') order by produk.terjual desc;
select*from CariProduk;
-- Harga (Termurah)
truncate CariProduk;alter table CariProduk change column `No(Terlaris)` `No(Harga Termurah)` int auto_increment;
insert into CariProduk (Nama,Harga,Rating,Terjual,Lokasi) select 
produk.nama,produk.harga,produk.rating,produk.terjual,pelapak.lokasi 
from produk,pelapak where produk.idPelapak=pelapak.id and produk.nama like concat('%',varNama,'%') order by produk.harga asc;
select*from CariProduk;
-- Harga (Termahal)
truncate CariProduk;alter table CariProduk change column `No(Harga Termurah)` `No(Harga Termahal)` int auto_increment;
insert into CariProduk (Nama,Harga,Rating,Terjual,Lokasi) select 
produk.nama,produk.harga,produk.rating,produk.terjual,pelapak.lokasi 
from produk,pelapak where produk.idPelapak=pelapak.id and produk.nama like concat('%',varNama,'%') order by produk.harga desc;
select*from CariProduk;
drop table if exists CariProduk;
end <>
delimiter ;
call cariProduk("headphone");