uses crt;

const
  // Alokasi maksimum member yang bisa disimpan di memori
  MAX_MEMBER = 100; 

type
  // Record untuk menyimpan data setiap member
  MemberRecord = record
    Username: string;
    Password: string;
  end;

var
  // Array untuk menyimpan semua data member
  MemberDatabase: array[1..MAX_MEMBER] of MemberRecord; 
  JumlahMember: integer; // Counter untuk jumlah member yang sudah terdaftar

  PilihanAwal, Pilihan1, PC, Beverages : integer;
  ulang: char;
  TotalHarga, HargaAkhir: real;
  Durasi: integer;
  HargaPC, HargaBeverages : real;
  Diskon: real;
  
  // Variabel untuk proses otentikasi
  UsernameInput, PasswordInput: string;
  StatusLogin: boolean; // True jika login berhasil
  StatusMember: char; // 'Y' (Member), 'N' (Guest)
  i: integer; 

// --- PROSEDUR PENDAFTARAN (SIGN UP) ---
procedure SignUp;
begin
  clrscr;
  writeln('===================================================');
  writeln('               PENDAFTARAN MEMBER BARU             ');
  writeln('===================================================');

  if JumlahMember >= MAX_MEMBER then
  begin
    writeln('Maaf, kuota pendaftaran member sudah penuh (', MAX_MEMBER, ').');
    readln;
    exit;
  end;

  // Tingkatkan jumlah member
  inc(JumlahMember);
  
  // Input data member baru
  write('Masukkan Username Baru (maks. 20 karakter): ');
  readln(MemberDatabase[JumlahMember].Username);
  write('Masukkan Password Baru (maks. 20 karakter): ');
  readln(MemberDatabase[JumlahMember].Password);
  
  writeln;
  writeln('Pendaftaran Berhasil! Username: ', MemberDatabase[JumlahMember].Username);
  writeln('Silahkan Login dengan Username dan Password Anda.');
  readln;
end;

// --- PROSEDUR LOGIN ---
procedure MemberLogin;
begin
  StatusLogin := False; 
  StatusMember := 'N'; 

  clrscr;
  writeln('===================================================');
  writeln('               SISTEM LOGIN MEMBER SSGM            ');
  writeln('===================================================');
  write('Masukkan Username: ');
  readln(UsernameInput);
  write('Masukkan Password: ');
  readln(PasswordInput);
  
  // Cek username dan password di daftar member yang sudah terdaftar
  for i := 1 to JumlahMember do
  begin
    if (UsernameInput = MemberDatabase[i].Username) and (PasswordInput = MemberDatabase[i].Password) then
    begin
      StatusLogin := True;
      StatusMember := 'Y';
      break; 
    end;
  end;
  
  if StatusLogin then
    begin
      writeln;
      writeln('LOGIN BERHASIL! Selamat datang, ', UsernameInput, '. Anda mendapatkan Diskon Member 10%.');
    end
  else
    begin
      writeln;
      writeln('LOGIN GAGAL! Username atau Password salah.');
    end;
  readln;
end;
// ----------------------

begin
  // --- INISIALISASI DATA AWAL ---
  JumlahMember := 0; // Mulai dengan 0 member terdaftar
  TotalHarga := 0; 
  Diskon := 0.0; 
  StatusMember := 'N'; // Default awal adalah Guest

  // Masukkan beberapa data member awal (opsional, untuk testing)
  JumlahMember := 2;
  MemberDatabase[1].Username := 'tester';
  MemberDatabase[1].Password := 'pass';
  MemberDatabase[2].Username := 'memberlama';
  MemberDatabase[2].Password := 'rahasia';
  
  // --- MENU PILIHAN AWAL: LOGIN, DAFTAR, atau GUEST ---
  repeat
    clrscr;
    writeln('==========================================================');
    writeln('           SELAMAT DATANG DI INTERNET CAFE SSGM           ');
    writeln('==========================================================');
    writeln('Silahkan pilih opsi Anda:');
    writeln('1. Login Member (Diskon 10%)');
    writeln('2. Daftar Member Baru');
    writeln('3. Lanjutkan sebagai Guest (Non-Member)');
    writeln('0. Keluar Dari Internet Cafe');
    write('Pilihan: ');
    readln(PilihanAwal);
    
    case PilihanAwal of
      1: // Login
        begin
          MemberLogin;
          if StatusMember = 'Y' then PilihanAwal := 3; // Jika berhasil login, lanjut ke menu utama (3)
        end;
      2: // Daftar
        begin
          SignUp;
        end;
      3: // Guest (Lanjut ke Menu Utama)
        begin
          if StatusMember = 'N' then // Jika belum login, set ke Guest
            writeln('Melanjutkan sebagai Guest (Non-Member).');
          readln;
        end;
      0: // Keluar Program
        begin
          exit; 
        end;
      else
        begin
          writeln('Inputan Tidak Valid. Silahkan Ulang.');
          readln;
        end;
    end;
  until (PilihanAwal = 3); // Loop hingga memilih Lanjut/Guest atau berhasil Login

  // --- MENU UTAMA (SETELAH OTENTIKASI) ---
  repeat
  
    clrscr;
    writeln('===================================================');
    writeln('           MENU UTAMA INTERNET CAFE SSGM           ');
    writeln('===================================================');
    // Jika member, tampilkan status member. Jika guest, tampilkan status guest.
    if StatusMember = 'Y' then
      writeln('Status: MEMBER (Diskon 10%)')
    else
      writeln('Status: GUEST (Non-Member)');
      
    writeln('Total Pesanan Anda Saat Ini: Rp ', TotalHarga:0:2); 
    writeln;

    writeln('Mau Pesan apa hari ini?');
    writeln('1. Mau Main Komputer Internet Cafe');
    writeln('2. Mau Pesan Snacks & Beverages');
    writeln('0. Keluar');
    write('Pilihan Anda: ');
    readln(Pilihan1);

    case Pilihan1 of
      1: // Main Komputer
        begin
          clrscr;
          writeln('--- MAIN KOMPUTER INTERNET CAFE ---');
          writeln('1. VIP (Rp 5.000,-/Jam)');
          writeln('2. Reguler (Rp 3.000,-/Jam)');
          write('Mau tipe apa komputernya? (1/2): ');
          readln(PC);

          write('Berapa Jam? :');
          readln(Durasi);
          
          HargaPC := 0; 

          case PC of
            1: HargaPC := 5000 * Durasi;
            2: HargaPC := 3000 * Durasi;
            else writeln('Pilihan Komputer Tidak Valid.');
          end;
          
          // Implementasi Diskon
          if (StatusMember = 'Y') and (HargaPC > 0) then
            begin
              Diskon := HargaPC * 0.10;
              HargaAkhir := HargaPC - Diskon;
              TotalHarga := TotalHarga + HargaAkhir;
              writeln('Diskon Member (10%): Rp ', Diskon:0:2);
              writeln('Harga Setelah Diskon: Rp ', HargaAkhir:0:2);
            end
          else if HargaPC > 0 then
            begin
              TotalHarga := TotalHarga + HargaPC;
              writeln('Harga Normal: Rp ', HargaPC:0:2);
            end;
            
          readln; 
        end;

      2: // Pesan Makanan/Minuman
        begin
          clrscr;
          writeln('--- PESAN SNACKS & BEVERAGES ---');
          writeln('1. Air Mineral (Rp 3.000,-)');
          writeln('2. MilkShake (Rp 10.000,-)');
          writeln('3. Susu Kedelai (Rp 5.000,-)');
          writeln('4. Soda (Rp 7.000,-)');
          writeln('5. Mie Instan (Rp 8.000,-)');
          writeln('6. Roti awokawoka (Rp 12.000,-)');
          writeln('7. Bakso Goreng (Rp 15.000,-)');
          writeln('8. Nasi Bungkus (Rp 10.000,-)');
          write('Pilihan Minuman/Makanan Anda (1-8): ');
          readln(Beverages);

          HargaBeverages := 0; 

          case Beverages of
            1: HargaBeverages := 3000;
            2: HargaBeverages := 10000;
            3: HargaBeverages := 5000;
            4: HargaBeverages := 7000;
            5: HargaBeverages := 8000;
            6: HargaBeverages := 12000;
            7: HargaBeverages := 15000;
            8: HargaBeverages := 10000;
            else writeln('Pilihan Makanan/Minuman Tidak Valid.');
          end;
          
          // Implementasi Diskon
          if (StatusMember = 'Y') and (HargaBeverages > 0) then
            begin
              Diskon := HargaBeverages * 0.10;
              HargaAkhir := HargaBeverages - Diskon;
              TotalHarga := TotalHarga + HargaAkhir;
              writeln('Diskon Member (10%): Rp ', Diskon:0:2);
              writeln('Harga Setelah Diskon: Rp ', HargaAkhir:0:2);
            end
          else if HargaBeverages > 0 then
            begin
              TotalHarga := TotalHarga + HargaBeverages;
              writeln('Item ditambahkan ke pesanan dengan Harga Normal.');
            end;

          readln; 
        end;

      0: // Keluar
        begin
          ulang := 'n'; 
        end;

      else 
        begin
          writeln('Inputan Tidak Valid, Silahkan Ulang.');
          readln;
        end;
    end;

    if Pilihan1 <> 0 then 
      begin
        write('Mau Pesan lagi? (y/n): ');
        readln(ulang);
      end

  until (Pilihan1 = 0) or ((ulang = 'n') or (ulang = 'N')); 

  // --- FINAL OUTPUT ---
  clrscr;
  writeln('===================================================');
  writeln('TERIMA KASIH telah berkunjung di Internet Cafe SSGM!');
  if StatusMember = 'Y' then
    writeln('Anda keluar sebagai MEMBER.')
  else
    writeln('Anda keluar sebagai GUEST (Non-Member).');
  writeln('---------------------------------------------------');
  writeln('Total yang harus Anda Bayar: Rp ', TotalHarga:0:2);
  writeln('===================================================');
  readln;

end.