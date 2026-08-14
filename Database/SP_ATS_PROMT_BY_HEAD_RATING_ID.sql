CREATE OR ALTER PROCEDURE dbo.SP_ATS_PROMT_BY_HEAD_RATING_ID
    @ATS_HEAD_RATING_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT
            CAST((
                SELECT
                    ISNULL(H.TOTAL_RATING_MARKS, 0) AS [Total Score],

                    CAST((
                        SELECT
                            R.ATS_RATING_MASTER_ID AS [Id],
                            R.DESCRIPTION AS [Key],
                            D.RATING_MARKS AS [Value],
                            JSON_QUERY('[' + ISNULL(kw.JsonArray, '') + ']') AS Keywords
                        FROM ATS_DTLS_RATING D
                        LEFT JOIN ATS_HEAD_RATING H2
                            ON H2.ATS_HEAD_RATING_ID = D.ATS_HEAD_RATING_ID
                        LEFT JOIN ATS_RATING_MASTER R
                            ON R.ATS_RATING_MASTER_ID = D.ATS_RATING_MASTER_ID
                        LEFT JOIN ATS_TYPE A
                            ON A.ATS_TYPE_ID = R.ATS_TYPE_ID
                        OUTER APPLY (
                            SELECT
                                STUFF((
                                    SELECT ',' + '"' + REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(s.value)), '\', '\\'), '"', '\"'), CHAR(10), '') + '"'
                                    FROM STRING_SPLIT(ISNULL(D.DESCRIPTION, ''), ',') AS s
                                    WHERE LTRIM(RTRIM(s.value)) <> ''
                                    FOR XML PATH(''), TYPE
                                ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS JsonArray
                        ) AS kw
                        WHERE D.ATS_HEAD_RATING_ID = H.ATS_HEAD_RATING_ID
                          AND A.ATS_TYPE_ID = 1
                        FOR JSON PATH
                    ) AS VARCHAR(MAX)) AS BreakDownScore,

                    CAST((
                        SELECT
                            R.ATS_RATING_MASTER_ID AS [Id],
                            R.DESCRIPTION AS [Key],
                            D.RATING_MARKS AS [Value]
                        FROM ATS_DTLS_RATING D
                        LEFT JOIN ATS_HEAD_RATING H2
                            ON H2.ATS_HEAD_RATING_ID = D.ATS_HEAD_RATING_ID
                        LEFT JOIN ATS_RATING_MASTER R
                            ON R.ATS_RATING_MASTER_ID = D.ATS_RATING_MASTER_ID
                        LEFT JOIN ATS_TYPE A
                            ON A.ATS_TYPE_ID = R.ATS_TYPE_ID
                        WHERE D.ATS_HEAD_RATING_ID = H.ATS_HEAD_RATING_ID
                          AND A.ATS_TYPE_ID = 2
                        FOR JSON PATH
                    ) AS VARCHAR(MAX)) AS [Result Status]
                FROM ATS_HEAD_RATING H
                WHERE H.ATS_HEAD_RATING_ID = @ATS_HEAD_RATING_ID
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            ) AS VARCHAR(MAX)) AS AtsPrompt;
    END TRY
    BEGIN CATCH
        SELECT '{"error": "' + STRING_ESCAPE(ERROR_MESSAGE(), 'json') + '"}' AS AtsPrompt;
    END CATCH
END
GO
