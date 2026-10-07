"""
File Name: TeamName_Practical_2.py
Team Name: ByteFlow
Student Numbers: 4332981, [INSERT OTHER STUDENT NUMBERS]
Description: Python script to connect to the UWC MySQL server, execute 10 queries 
for the Pixel Arena Gaming Lounge scenario, and display the results.
"""
"""BEGIN"""
import mysql.connector
from mysql.connector import Error

def execute_and_print(cursor, query_name, query):
    """Helper function to execute a query and print its results cleanly."""
    print(f"\n--- {query_name} ---")
    cursor.execute(query)
    results = cursor.fetchall()
    
    # Fetch column headers
    column_names = [i[0] for i in cursor.description]
    print(f"{' | '.join(column_names)}")
    print("-" * 50)
    
    # Print rows
    for row in results:
        print(f"{' | '.join(str(item) for item in row)}")
    print("\n")

def main():
    try:
        # Connect to the UWC MySQL Server using your specific credentials
        connection = mysql.connector.connect(
            host='172.21.12.21',
            port=22981,
            user='student_4332981',
            password='!St4332981',
            database='student_4332981', # Using your username as the DB name per UWC setup
            ssl_disabled=False # SSL is required by the UWC server
        )

        if connection.is_connected():
            print("Successfully connected to the UWC MySQL server.")
            cursor = connection.cursor()

            # --- 2 SIMPLE QUERIES ---
            q1 = "SELECT Station_ID, Hourly_Rate FROM Gaming_Station WHERE Tier = 'VIP_Pro';"
            execute_and_print(cursor, "Query 1 (Simple): VIP Pro Stations", q1)

            q2 = "SELECT Username, Email FROM Gamer ORDER BY Username ASC;"
            execute_and_print(cursor, "Query 2 (Simple): Gamer Contact List", q2)

            # --- 4 MEDIUM QUERIES ---
            q3 = """
            SELECT CONCAT(g.Username, ' - ', gp.Phone_Number) AS Contact_Info
            FROM Gamer g
            INNER JOIN Gamer_Phone gp ON g.Gamer_ID = gp.Gamer_ID;
            """
            execute_and_print(cursor, "Query 3 (Medium): Formatted Phone List", q3)

            q4 = """
            SELECT s.Name, COUNT(gs.Session_ID) AS Total_Sessions_Handled
            FROM Staff s
            LEFT JOIN Gaming_Session gs ON s.Staff_ID = gs.Staff_ID
            GROUP BY s.Name;
            """
            execute_and_print(cursor, "Query 4 (Medium): Sessions Handled per Staff", q4)

            q5 = """
            SELECT Station_ID, Tier, Hourly_Rate 
            FROM Gaming_Station 
            WHERE Hourly_Rate > (SELECT AVG(Hourly_Rate) FROM Gaming_Station);
            """
            execute_and_print(cursor, "Query 5 (Medium): Stations Above Average Rate", q5)

            q6 = """
            SELECT SUM(Duration_Hours) AS Total_Hours_Played_Oct
            FROM Gaming_Session
            WHERE MONTH(Start_Time) = 10 AND YEAR(Start_Time) = 2026;
            """
            execute_and_print(cursor, "Query 6 (Medium): Total Hours Played in Oct 2026", q6)

            # --- 4 COMPLEX QUERIES ---
            q7 = """
            SELECT g.Username, SUM(i.Total_Amount) AS Total_Spent
            FROM Gamer g
            INNER JOIN Gaming_Session gs ON g.Gamer_ID = gs.Gamer_ID
            INNER JOIN Invoice i ON gs.Session_ID = i.Session_ID
            WHERE i.Payment_Status = 'Paid'
            GROUP BY g.Username
            HAVING SUM(i.Total_Amount) > 40.00;
            """
            execute_and_print(cursor, "Query 7 (Complex): Gamers spending > $40", q7)

            q8 = """
            SELECT g.Username, g.Age, st.Tier, gs.Duration_Hours
            FROM Gamer g
            INNER JOIN Gaming_Session gs ON g.Gamer_ID = gs.Gamer_ID
            INNER JOIN Gaming_Station st ON gs.Station_ID = st.Station_ID
            WHERE (g.Age < 25 AND st.Tier = 'VIP_Pro') OR (gs.Duration_Hours > 3.0);
            """
            execute_and_print(cursor, "Query 8 (Complex): Young VIP Gamers OR Long Sessions", q8)

            q9 = """
            SELECT s.Name 
            FROM Staff s
            INNER JOIN Gaming_Session gs ON s.Staff_ID = gs.Staff_ID
            INNER JOIN Invoice i ON gs.Session_ID = i.Session_ID
            GROUP BY s.Name
            HAVING SUM(i.Total_Amount) > (SELECT AVG(Total_Amount) FROM Invoice);
            """
            execute_and_print(cursor, "Query 9 (Complex): Staff Processing Above-Average Revenue", q9)

            q10 = """
            SELECT st.Tier, AVG(gs.Duration_Hours) AS Avg_Session_Length, SUM(i.Total_Amount) AS Total_Revenue
            FROM Gaming_Station st
            INNER JOIN Gaming_Session gs ON st.Station_ID = gs.Station_ID
            INNER JOIN Invoice i ON gs.Session_ID = i.Session_ID
            GROUP BY st.Tier
            HAVING SUM(i.Total_Amount) > 50.00
            ORDER BY Total_Revenue DESC;
            """
            execute_and_print(cursor, "Query 10 (Complex): Profitable Hardware Tiers", q10)

    except Error as e:
        print(f"Error connecting to UWC MySQL Server: {e}")
    
    finally:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()
            print("MySQL connection is closed.")

if __name__ == "__main__":
    main()

"""END"""