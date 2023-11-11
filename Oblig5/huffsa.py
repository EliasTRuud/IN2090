import psycopg2

# 
"""
psql -h dbpg-ifi-kurs03 -U arneet_priv -d arneet
pw: eipho7zoaW
"""

user = 'arneet' # Sett inn ditt UiO-brukernavn ("_priv" blir lagt til under)
pwd = 'eipho7zoaW' # Sett inn passordet for _priv-brukeren du fikk i en mail

connection = \
    "dbname='" + user + "' " +  \
    "user='" + user + "_priv' " + \
    "port='5432' " +  \
    "host='dbpg-ifi-kurs03.uio.no' " + \
    "password='" + pwd + "'"

def huffsa():
    conn = psycopg2.connect(connection)
    
    ch = 0
    while (ch != 3):
        print("--[ HUFFSA ]--")
        print("Vennligst velg et alternativ:\n 1. Søk etter planet\n 2. Legg inn forsøksresultat\n 3. Avslutt")
        ch = int(input("Valg: "))

        if (ch == 1):
            planet_sok(conn)
        elif (ch == 2):
            sett_inn_resultat(conn)
 
def planet_sok(conn):
    # TODO: Oppg 1
    print(" -- PLANET-SØK --")
    print("Velg molekyler")
    mol1 = input("Molekyl 1: ")
    mol2 = input("Molekyl 2: ")
    
    print("How should the results be sorted?\n1.\n2. by name")

    q = "SELECT p.navn, p.masse AS pmasse, s.masse AS smasse, s.avstand, liv " + \
        "FROM planet p INNER JOIN stjerne s ON p.stjerne = s.navn " + \
        "WHERE p.navn IN (SELECT m.planet FROM materie m WHERE molekyl LIKE %(mol1)s) "

    if mol2 != "":
        q += " AND p.navn IN (SELECT m.planet FROM materie m WHERE molekyl LIKE %(mol2)s) "

    q += "ORDER BY avstand DESC;"

    # pulled from ukesoppg
    cur = conn.cursor()
    # We can then give a map from placeholder name to value, like below
    cur.execute(q, {'mol1' : mol1,'mol2' : mol2})
    rows = cur.fetchall()

    if (rows == []):
        print("No results.")
        return

    print(" -- RESULTS --\n")

    for row in rows:
        print("Navn: " + row[0] + "\n" + 
              "Planet-masse: " + str(row[1]) + "\n" + 
              "Stjerne-masse: " + str(row[2]) + "\n" +
              "Stjerne-distane: " + str(row[3]) +  "\n" +
              "Bekreftet liv: " + ("Ja" if row[4] else "Nei" ) )
        print("\n")

def sett_inn_resultat(conn):
    # TODO: Oppg 2
    """
    Oppdater planet-tabellen basert på brukerens input. Du kan anta at brukeren alltid oppgir verdier for alle feltene, 
    og at den alltid oppgir j eller n på Skummel og Intelligent.
    """
    print(" --[ LEGG INN RESULTAT ]--\n")
    navn = input("Planet: ")
    skummel = input("Skummel: ")
    sk = True if skummel == "j" else False
    inte = input("Intelligent: ")
    intel = True if inte == "j" else False
    beskr = input("Beskrivelse: ")
    ## Input a result with a query
    iq = "UPDATE planet " + \
         "SET skummel = %(skummel)s, intelligent = %(intelligent)s, beskrivelse = %(beskrivelse)s " + \
         "WHERE navn = %(navn)s;"

    cur = conn.cursor()
    cur.execute(iq, {'navn' : navn, 'skummel' : sk, 'intelligent' : intel, 'beskrivelse' : beskr}) 
    conn.commit()
    print("Result updated ordered.")


if __name__ == "__main__":
    huffsa()
