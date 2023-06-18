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

call validasiLoginViaNoTelp('99999999999','ilham7580');
call validasiLoginViaNoTelp('08129022310','hhhhhhhhh');
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

call validasiLoginViaEmail('hhhhh@gmail.com','ilham7580');
call validasiLoginViaEmail('ilham@gmail.com','hhhhhhhhh');
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
call lihatPromoPengguna('santoso');
call lihatPromoPengguna('liliaz');

select*from pengguna;
select*from produk;
select*from dompetDigital;
select*from dompetTerhubung;
select*from promo;
select*from promoTerhubung;
select*from alamat;
select*from pesanan;
select*from detailPesanan;

delimiter <>
create or replace procedure pesan(varUsername varchar(255),varPromo varchar(255),varAlamat varchar(255),
					   varDompet varchar(255),varTanggal date,listProduk varchar(255),listJumlah varchar(255),varCatatan text)
begin
declare varIdPengguna char(36);
declare varIdPromo char(36);
declare varIdAlamat char(36);
declare varIdDompet char(36);
declare varIdProduk char(36);
declare warning varchar(255);
declare cekKoma int default 1;
declare i int default 1;
declare varProduk varchar(255);
declare varJumlah varchar(255);
declare cekStok int;
declare varHarga decimal(10,2);
declare varMinTransaksi decimal(10,2);
declare varUUID char(36);
declare cekUUID int default 0;
set varUUID=uuid();
set varIdPengguna=(select id from pengguna where username=varUsername);
set varIdPromo=(select id from promo join promoTerhubung where promo.id=promoTerhubung.idPromo and idPengguna=varIdPengguna and promo.nama=varPromo);
set varIdAlamat=(select id from alamat where idPengguna=varIdPengguna and alamat=varAlamat);
set varIdDompet=(select id from dompetDigital join dompetTerhubung where dompetDigital.id=dompetTerhubung.idDompet and idPengguna=varIdPengguna and dompetDigital.nama=varDompet);
if(varIdPengguna is null) then
	set warning= concat("Username pengguna '",varUsername, "' tidak diketahui");
	signal sqlstate '44444' set message_text = warning;
elseif(varIdAlamat is null) then
	set warning= concat("Username pengguna '",varUsername, "' tidak memiliki alamat '",varAlamat,"'");
	signal sqlstate '44444' set message_text = warning;
elseif(varIdDompet is null) then
	set warning= concat("Username pengguna '",varUsername, "' tidak memiliki dompet '",varDompet,"'");
	signal sqlstate '44444' set message_text = warning;
end if;
create table if not exists Pemberitahuan (pemberitahuan varchar(255));
while(cekKoma!=0) do
-- select cekKoma;
	set cekKoma=(select locate(',',listProduk,cekKoma+1)); -- cekKoma default 1
    set varProduk=(select substring_index(substring_index(listProduk, ',', i), ',', -1));
    set varIdProduk=(select id from produk where nama=varProduk);
-- select cekKoma, varProduk,varIdProduk,i;
	if(varIdProduk is not null) then
        set varJumlah=(select substring_index(substring_index(listJumlah, ',', i), ',', -1));
		set cekStok=(select stok from produk where id=varIdProduk);
        if(varJumlah<=cekStok) then
			set cekUUID=1;
            if((select id from pesanan where id=varUUID) is null) then
				insert into pesanan(id,idPengguna,idAlamat,idDompet,tanggal,catatan,status) values
				(varUUID,varIdPengguna,varIdAlamat,varIdDompet,varTanggal,varCatatan,'Sedang diproses');
			end if;
			insert into detailPesanan(idPesanan,idProduk,jumlah) values
			(varUUID,varIdProduk,varJumlah);
			update produk set stok=stok-varJumlah,terjual=terjual+varJumlah where id=varIdProduk;
		else
			insert into Pemberitahuan values (concat('Stok ',varProduk,' tidak mencukupi'));
		end if;
	else
		insert into Pemberitahuan values (concat(varProduk,' tidak diketahui'));
	end if;
    set i=i+1;
    select i;
end while;
set varHarga=(select produk.harga*detailPesanan.jumlah from pesanan left join detailPesanan on pesanan.id=detailPesanan.idPesanan
join produk on detailPesanan.idProduk=produk.id where pesanan.id=(select id from pesanan order by id desc limit 1) group by pesanan.id);
set varMinTransaksi=(select minTransaksi from promo where id=varIdPromo);
if(cekUUID=1) then -- jika terdapat pesanan barang yang valid
	if(varIdPromo is not null) then
		if(varHarga>=varMinTransaksi) then
			update pesanan set idPromo=varIdPromo where id=(select id from pesanan order by id desc limit 1);
			delete from promoTerhubung where idPengguna=varIdPengguna and idPromo=varIdPromo;
		else
			insert into Pemberitahuan values (concat('Total harga pesanan = ', varHarga, '> kriteria min transaksi ', varPromo, '= ',varMinTransaksi));
		end if;
	end if;
end if;
select*from Pemberitahuan;
drop table if exists Pemberitahuan;
end <>
delimiter ;
select*from promo;

call pesan('hafiz','','Jl. Siput No. 123','OVO','2023-06-07','Headphone Sony',1,'');
call pesan('ilhamz','','Jl. Siput No. 123','OVO','2023-06-07','Headphone Sony',1,'');
call pesan('ilhamz','','Jl. Rambutan No. 123','GoPay','2023-06-07','Headphone Sony',1,'');
call pesan('ilhamz','','Jl. Rambutan No. 123','OVO','2023-06-07','Headphone Asus',1,'');
call pesan('ilhamz','','Jl. Rambutan No. 123','OVO','2023-06-07','Headphone Sony',1,'Cepat kirim');
call pesan('ilhamz','Promo Lebaran','Jl. Rambutan No. 123','OVO','2023-06-07','Headphone Sony',2,'Cepat kirim');
call pesan('ilhamz','Promo Lebaran','Jl. Rambutan No. 123','OVO','2023-06-07','Kemeja Denim',3,'');
call pesan('budiz','Promo Lebaranz','Jl. Mangga No. 456','BCA','2023-06-08','Laptop Asus ZenForce',1,'');
call pesan('budiz','Promo Lebaran','Jl. Mangga No. 456','GoPay','2023-06-08','Sepatu Nike Running,Kemeja Denim','1, 2','');
call pesan('budiz','Promo Lebaran','Jl. Mangga No. 456','GoPay','2023-06-09','Headphone Sony,Kemeja Denim,Laptop Asus ZenForce,Carolina Herera,Sepatu Nike Running,Baju Renang','2,4,1,3,30,2','');

select coalesce((select id from promo join promoTerhubung where promo.id=promoTerhubung.idPromo and idPengguna='92332b2a-0ad4-11ee-80fd-00155d02be68' and promo.nama='Promo Lebaranz'),'-');
select*from detailpesanan;
select locate(',','Kemeja Demis,Headphone Sony,',1);
select replace('Kemeja Demis,Headphone Sony, a',',',' ',1);
select substring('Kemeja Demis,Headphone Sony',1,(select locate(',','Kemeja Demis,Headphone Sony',1)-0-1)); -- tidak termasuk koma
select locate(',','Kemeja Demis,Headphone Sony',14);
select substring('Kemeja Demis,Headphone Sony',14); -- if !=0
select substring('Kemeja Demis,Headphone Sony,',14,(select locate(',','Kemeja Demis,Headphone Sony,',14)-13-1));
select SUBSTRING_INDEX('Kemeja Demis', ',', 1);
select SUBSTRING_INDEX('Kemeja Demis,Headphone Sony,', ',', 1);
select substring_index(substring_index('Kemeja Demis,Headphone Sony,a', ',', 1), ',', -1);

select locate(',','4,33',1);
select substring('4,33',1,(select locate(',','4,33',1)-0-1)); -- tidak termasuk koma
select locate(',','4,33',3);
select substring('Kemeja Demis,Headphone Sony',14); -- if !=0
select substring('Kemeja Demis,Headphone Sony,',14,(select locate(',','Kemeja Demis,Headphone Sony,',14)-13-1));

