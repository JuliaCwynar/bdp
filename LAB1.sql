-- Tworze tabele
CREATE TABLE ksiegowosc.pracownicy (
    id_pracownika SERIAL PRIMARY KEY,
    imie VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    adres TEXT,
    telefon VARCHAR(15)
);
COMMENT ON TABLE ksiegowosc.pracownicy IS 'Dane o pracownikach firmy';

CREATE TABLE ksiegowosc.godziny (
    id_godziny SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    liczba_godzin INTEGER NOT NULL,
    id_pracownika INT REFERENCES ksiegowosc.pracownicy(id_pracownika) ON DELETE CASCADE
);
COMMENT ON TABLE ksiegowosc.godziny IS 'Dane o liczbach godzin przepracowanych przez pracownika.';


CREATE TABLE ksiegowosc.pensja (
    id_pensji SERIAL PRIMARY KEY,
    stanowisko VARCHAR(50) NOT NULL,
    kwota DECIMAL(10, 2) NOT NULL
);
COMMENT ON TABLE ksiegowosc.pensja IS 'Dane o wynagrodzeniach dla stanowisk';


CREATE TABLE ksiegowosc.premia (
    id_premii SERIAL PRIMARY KEY,
    rodzaj VARCHAR(50) NOT NULL,
    kwota DECIMAL(10, 2) NOT NULL
);
COMMENT ON TABLE ksiegowosc.premia IS 'Dane o premiach przyznanych pracownikom';

CREATE TABLE ksiegowosc.wynagrodzenie (
    id_wynagrodzenia SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    id_pracownika INT REFERENCES ksiegowosc.pracownicy(id_pracownika),
    id_godziny INT REFERENCES ksiegowosc.godziny(id_godziny),
    id_pensji INT REFERENCES ksiegowosc.pensja(id_pensji),
    id_premii INT REFERENCES ksiegowosc.premia(id_premii)
);
COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Dane o wynagrodzeniach pracowników (godziny pracy, premie, pensja)';

-- Wypelniam  po 10 rekordow kazda

INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon) VALUES 
('Jan', 'Kowalski', 'ul. Zielona 10, Warszawa', '123456789'),
('Anna', 'Nowak', 'ul. Czerwona 5, Krakow', '987654321'),
('Piotr', 'Zielinski', 'ul. Niebieska 20, Gdansk', '5647382910'),
('Katarzyna', 'Lewandowska', 'ul. Jasna 3, Poznan', '5647382019'),
('Robert', 'Nowak', 'ul. Słoneczna 8, Warszawa', '1122334455'),
('Maria', 'Kowalska', 'ul. Polna 9, Wroclaw', '9988776655'),
('Jakub', 'Wiśniewski', 'ul. Morska 4, Gdynia', '7744556611'),
('Joanna', 'Baran', 'ul. Ogrodowa 2, Lublin', '7766889977'),
('Paweł', 'Dąbrowski', 'ul. Leśna 7, Opole', '3355778899'),
('Alicja', 'Szulc', 'ul. Wiosenna 9, Katowice', '6655443322');

INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika) VALUES 
('2024-01-05', 160, 1),
('2024-02-06', 170, 2),
('2024-03-07', 155, 3),
('2024-04-08', 180, 4),
('2024-05-09', 160, 5),
('2024-06-10', 200, 6),
('2024-07-11', 150, 7),
('2024-08-12', 165, 8),
('2024-09-13', 175, 9),
('2024-10-14', 190, 10);

DROP TABLE ksiegowosc.pensja;
DROP TABLE ksiegowosc.wynagrodzenie;

INSERT INTO ksiegowosc.pensja (stanowisko, kwota) VALUES 
('Kierownik', 5000.00),
('Developer', 4500.00),
('Tester', 3000.00),
('HR', 900.00),
('Księgowa', 800.00),
('Analityk', 4800.00),
('Support', 2800.00),
('Admin', 3600.00),
('QA', 4200.00),
('Konsultant', 600.00);

INSERT INTO ksiegowosc.premia (rodzaj, kwota) VALUES 
('Performance', 500.00),
('Świeta', 800.00),
('Bonus', 1200.00),
('Koniec roku', 1000.00),
('Polecenie', 1500.00),
('Nadgodziny', 750.00),
('Milestone', 900.00),
('Patent', 1100.00),
('Osiągnięcie naukowe', 1300.00),
('Uznanie', 1400.00);

INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES 
('2024-01-31', 1, 1, 1, NULL),
('2024-02-28', 2, 2, 2, 2),
('2024-03-31', 3, 3, 3, NULL),
('2024-04-30', 4, 4, 4, 4),
('2024-05-31', 5, 5, 5, 5),
('2024-06-30', 6, 6, 6, NULL),
('2024-07-31', 7, 7, 7, 7),
('2024-08-31', 8, 8, 8, 8),
('2024-09-30', 9, 9, 9, 9),
('2024-10-31', 10, 10, 10, 10);

-- Wyswietlam tabele dla sprawdzenia

SELECT * FROM ksiegowosc.pracownicy;
SELECT * FROM ksiegowosc.godziny;
SELECT * FROM ksiegowosc.pensja;
SELECT * FROM ksiegowosc.premia;
SELECT * FROM ksiegowosc.wynagrodzenie;


-- Polecenia

-- a) Wyświetl tylko id pracownika oraz jego nazwisko.
SELECT id_pracownika, nazwisko FROM ksiegowosc.pracownicy;

-- b) Wyświetl id pracowników, których płaca jest większa niż 1000.
SELECT p.id_pracownika FROM ksiegowosc.pracownicy p 
JOIN ksiegowosc.pensja pen ON p.id_pracownika = pen.id_pensji
WHERE pen.kwota > 1000;

-- c) Wyświetl id pracowników nieposiadających premii, których płaca jest większa niż 2000.
SELECT p.id_pracownika FROM ksiegowosc.pracownicy p 
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika 
JOIN ksiegowosc.pensja pen ON w.id_pensji = pen.id_pensji 
WHERE pen.kwota > 2000 AND w.id_premii IS NULL;

-- d) Wyświetl pracowników, których pierwsza litera imienia zaczyna się na literę ‘J’.
SELECT * FROM ksiegowosc.pracownicy WHERE imie LIKE 'J%';

-- e) Wyświetl pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’.
SELECT * FROM ksiegowosc.pracownicy WHERE nazwisko LIKE '%n%' AND imie LIKE '%a';

-- f) Wyświetl imię i nazwisko pracowników oraz liczbę ich nadgodzin, przyjmując, iż standardowy czas pracy to 160 h miesięcznie.
SELECT p.imie, p.nazwisko, SUM(g.liczba_godzin - 160) AS nadgodziny 
FROM ksiegowosc.pracownicy p 
JOIN ksiegowosc.godziny g ON p.id_pracownika = g.id_pracownika 
WHERE g.liczba_godzin > 160 
GROUP BY p.imie, p.nazwisko;

-- g) Wyświetl imię i nazwisko pracowników, których pensja zawiera się w przedziale 1500 – 3000 PLN.
SELECT p.imie, p.nazwisko FROM ksiegowosc.pracownicy p 
JOIN ksiegowosc.pensja pen ON p.id_pracownika = pen.id_pensji 
WHERE pen.kwota BETWEEN 1500 AND 3000;

-- h) Wyświetl imię i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii.
SELECT p.imie, p.nazwisko FROM ksiegowosc.pracownicy p 
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika 
JOIN ksiegowosc.godziny g ON p.id_pracownika = g.id_pracownika 
WHERE g.liczba_godzin > 160 AND w.id_premii IS NULL;

-- i) Uszereguj pracowników według pensji.
SELECT p.imie, p.nazwisko FROM ksiegowosc.pracownicy p 
JOIN ksiegowosc.pensja pen ON p.id_pracownika = pen.id_pensji 
ORDER BY pen.kwota ASC;

-- j) Uszereguj pracowników według pensji i premii malejąco.
SELECT pen.stanowisko, COUNT(*) FROM ksiegowosc.pensja pen 
JOIN ksiegowosc.wynagrodzenie w ON pen.id_pensji = w.id_pensji 
GROUP BY pen.stanowisko;

-- k) Zlicz i pogrupuj pracowników według pola ‘stanowisko’.
SELECT stanowisko, COUNT(*) FROM ksiegowosc.pensja GROUP BY stanowisko;

-- l) Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘kierownik’ (jeżeli takiego nie masz, to przyjmij dowolne inne).
SELECT AVG(kwota) AS avg_pay, MIN(kwota) AS min_pay, MAX(kwota) AS max_pay FROM ksiegowosc.pensja WHERE stanowisko = 'Kierownik';

-- m) Policz sumę wszystkich wynagrodzeń.
SELECT SUM(kwota) AS total_salary FROM ksiegowosc.pensja;

-- f) Policz sumę wynagrodzeń w ramach danego stanowiska.
SELECT stanowisko, SUM(kwota) AS total_salary FROM ksiegowosc.pensja GROUP BY stanowisko;

-- g) Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska.
SELECT pen.stanowisko, COUNT(w.id_premii) AS bonus_count 
FROM ksiegowosc.wynagrodzenie w 
JOIN ksiegowosc.pensja pen ON w.id_pensji = pen.id_pensji 
GROUP BY pen.stanowisko;

--h) Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł.
DELETE FROM ksiegowosc.wynagrodzenie
WHERE id_pracownika IN (
	SELECT p.id_pracownika 
	FROM ksiegowosc.pracownicy AS p
	JOIN ksiegowosc.wynagrodzenie AS w 
	ON p.id_pracownika = w.id_pracownika
	JOIN ksiegowosc.pensja AS pe 
	ON w.id_pensji = pe.id_pensji
	WHERE pe.kwota < 1200
);

SELECT * FROM ksiegowosc.wynagrodzenie;
