def get_query_by_category(category, where_str):
    if category == "artists":
        return f"""
            WITH RECURSIVE split(name, rest) AS (
                SELECT 
                    TRIM(SUBSTR(REPLACE(m.artists, "'", "") || ';', 1, INSTR(REPLACE(m.artists, "'", "") || ';', ';') - 1)),
                    SUBSTR(REPLACE(m.artists, "'", "") || ';', INSTR(REPLACE(m.artists, "'", "") || ';', ';') + 1)
                FROM scrobbles s
                JOIN metadata_ref m ON s.track_id = m.track_id
                {where_str}
                UNION ALL
                SELECT 
                    TRIM(SUBSTR(rest, 1, INSTR(rest, ';') - 1)),
                    SUBSTR(rest, INSTR(rest, ';') + 1)
                FROM split WHERE rest <> ''
            )
            SELECT name, COUNT(*) as count, 
            (SELECT l.url FROM library l WHERE l.id = py_md5(name) AND l.type = 1 LIMIT 1) as album_img
            FROM split WHERE name <> ''
            GROUP BY UPPER(name) ORDER BY count DESC
        """

    elif category == "albums":
        return f"""
            SELECT REPLACE(m.album, "'", "") as name, 
                   REPLACE(m.main_artist, "'", "") as artist, 
                   COUNT(*) as count, l.url as album_img
            FROM scrobbles s
            JOIN metadata_ref m ON s.track_id = m.track_id
            LEFT JOIN library l ON REPLACE(s.album_id, "'", "") = l.id AND l.type = 2
            {where_str}
            GROUP BY m.album, m.main_artist ORDER BY count DESC
        """

    elif category == "artists_with_detail":
            return f"""
                SELECT name, COUNT(*) as count,
                       GROUP_CONCAT(album_info, ' | ') as detail
                FROM (
                    SELECT 
                        TRIM(SUBSTR(REPLACE(m.artists, "'", "") || ';', 1, INSTR(REPLACE(m.artists, "'", "") || ';', ';') - 1)) as name,
                        REPLACE(m.album, "'", "") || ' (' || COUNT(*) || ')' as album_info
                    FROM scrobbles s
                    JOIN metadata_ref m ON s.track_id = m.track_id
                    {where_str}
                    GROUP BY name, m.album
                    ORDER BY COUNT(*) DESC
                ) AS sub_detail
                GROUP BY name
                ORDER BY count DESC
            """
    
    elif category == "tracks":
        return f"""
                SELECT REPLACE(m.track, "'", "") as name, 
                       REPLACE(m.artists, "'", "") as artist, 
                       COUNT(*) as count, 
                       l.url as album_img
                FROM scrobbles s
                JOIN metadata_ref m ON s.track_id = m.track_id
                LEFT JOIN library l ON REPLACE(s.album_id, "'", "") = l.id AND l.type = 2
                {where_str}
                GROUP BY name, artist 
                ORDER BY count DESC
            """

    elif category == "daily_scrobbles":
        return f"""
            SELECT strftime('%Y-%m-%d', datetime(s.timestamp, 'unixepoch', 'localtime')) as day, 
                   COUNT(*) as count
            FROM scrobbles s
            JOIN metadata_ref m ON s.track_id = m.track_id
            {where_str}
            GROUP BY day ORDER BY day ASC
        """

    elif category == "artist_evolution":
        return f"""
            SELECT name, day, COUNT(*) as count
            FROM (
                SELECT REPLACE(m.main_artist, "'", "") as name,
                       strftime('%Y-%m-%d', datetime(s.timestamp, 'unixepoch', 'localtime')) as day
                FROM scrobbles s
                JOIN metadata_ref m ON s.track_id = m.track_id
                {where_str}
            ) AS sub_evo
            GROUP BY name, day ORDER BY day ASC
        """

    elif category == "stats_decades":
            return f"""
                SELECT 
                    (CAST(REPLACE(m.release_year, "'", "") AS INTEGER) / 10 * 10) || 's' as name, 
                    COUNT(*) as count 
                FROM scrobbles s 
                JOIN metadata_ref m ON s.track_id = m.track_id 
                {where_str} 
                AND CAST(REPLACE(m.release_year, "'", "") AS INTEGER) >= 1920 
                AND CAST(REPLACE(m.release_year, "'", "") AS INTEGER) <= strftime('%Y', 'now')
                GROUP BY name 
                HAVING name IS NOT NULL
                ORDER BY name ASC
            """
    elif category == "top_artists_with_projects":
               return f"""
                   WITH RECURSIVE split(name) AS (
                       SELECT 
                           TRIM(SUBSTR(REPLACE(m.artists, "'", "") || ';', 1, INSTR(REPLACE(m.artists, "'", "") || ';', ';') - 1))
                       FROM scrobbles s
                       JOIN metadata_ref m ON s.track_id = m.track_id
                       {where_str}
                       UNION ALL
                       SELECT 
                           TRIM(SUBSTR(REPLACE(m.artists, "'", "") || ';', INSTR(REPLACE(m.artists, "'", "") || ';', ';') + 1))
                       FROM scrobbles s -- Note: cette partie nécessite une logique de split plus complexe en SQLite pur, 
                                       -- utilisons une version simplifiée plus performante pour ton cas :
                   )
                   /* Version optimisée pour ton Top 20 incluant les feats */
                   SELECT 
                       name, 
                       COUNT(*) as count,
                       (SELECT l.url FROM library l WHERE l.id = py_md5(name) AND l.type = 1 LIMIT 1) as album_img,
                       (
                           SELECT GROUP_CONCAT(alb, ' | ') FROM (
                               SELECT REPLACE(m2.album, "'", "") || ' (' || COUNT(*) || ')' as alb
                               FROM scrobbles s2
                               JOIN metadata_ref m2 ON s2.track_id = m2.track_id
                               WHERE REPLACE(m2.artists, "'", "") LIKE '%' || sub.name || '%'
                               GROUP BY m2.album ORDER BY COUNT(*) DESC LIMIT 10
                           )
                       ) as detail
                   FROM (
                       /* On utilise ici ta logique de split existante dans la catégorie 'artists' */
                       WITH RECURSIVE split(name, rest) AS (
                           SELECT 
                               TRIM(SUBSTR(REPLACE(m.artists, "'", "") || ';', 1, INSTR(REPLACE(m.artists, "'", "") || ';', ';') - 1)),
                               SUBSTR(REPLACE(m.artists, "'", "") || ';', INSTR(REPLACE(m.artists, "'", "") || ';', ';') + 1)
                           FROM scrobbles s
                           JOIN metadata_ref m ON s.track_id = m.track_id
                           {where_str}
                           UNION ALL
                           SELECT 
                               TRIM(SUBSTR(rest, 1, INSTR(rest, ';') - 1)),
                               SUBSTR(rest, INSTR(rest, ';') + 1)
                           FROM split WHERE rest <> ''
                       )
                       SELECT name FROM split WHERE name <> ''
                   ) as sub
                   GROUP BY name
                   ORDER BY count DESC
                   LIMIT 20
               """   
    else: # Par défaut : historique
        return f"""
            SELECT REPLACE(m.track, "'", "") as name, 
                   REPLACE(m.artists, "'", "") as artist, 
                   s.timestamp, l.url as album_img
            FROM scrobbles s
            JOIN metadata_ref m ON s.track_id = m.track_id
            LEFT JOIN library l ON REPLACE(s.album_id, "'", "") = l.id AND l.type = 2
            {where_str} ORDER BY s.timestamp DESC
        """
