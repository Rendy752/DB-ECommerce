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