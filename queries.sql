#
# 1. Get all the questionnaires with their questions
#
SELECT
  qr.*,
  qn.*
FROM
  questionnaire qr
    INNER JOIN questionnaire_questions qq
               ON qr.id = qq.qr_id
    INNER JOIN questions qn
               ON qq.qn_id = qn.id
ORDER BY
  qr.id, qn.id;

#
# 2. Get all the questionnaires that were answered in the last month
#
# Notes:
# a) "Last Month" has been regarded the period between the start-day of the previous month
#     (eg. January if now is February).
# b) Even if only one answer is given within the period, the Questionnaire is eligible for display.
#
SELECT
  qr.*
FROM
  questionnaire qr
    INNER JOIN questionnaire_questions qq
               ON qr.id = qq.qr_id
    INNER JOIN questions qn
               ON qq.qn_id = qn.id
    INNER JOIN questions_answer_options qao
               ON qn.id = qao.qn_id
    INNER JOIN responders_answers ra
               ON qao.id = ra.an_id
WHERE
  ra.datetime_added BETWEEN
    /* Greater or equal to the start of last month */
    DATE_ADD(LAST_DAY(DATE_SUB(NOW(), INTERVAL 2 MONTH)), INTERVAL 1 DAY) AND
    /* Smaller or equal than one month ago */
    LAST_DAY(DATE_SUB(NOW(), INTERVAL 1 MONTH))
GROUP BY
  qr.id;

#
# 3. Get all the questionnaires with more than 5 questions answered in the last month
#
SELECT
  qr.*,
  COUNT(ra.id) AS answers_count
FROM
  questionnaire qr
    INNER JOIN questionnaire_questions qq
               ON qr.id = qq.qr_id
    INNER JOIN questions qn
               ON qq.qn_id = qn.id
    INNER JOIN questions_answer_options qao
               ON qn.id = qao.qn_id
    INNER JOIN responders_answers ra
               ON qao.id = ra.an_id
WHERE
  ra.datetime_added BETWEEN
    /* Greater or equal to the start of last month */
    DATE_ADD(LAST_DAY(DATE_SUB(NOW(), INTERVAL 2 MONTH)), INTERVAL 1 DAY) AND
    /* Smaller or equal than one month ago */
    LAST_DAY(DATE_SUB(NOW(), INTERVAL 1 MONTH))
GROUP BY
  qr.id
HAVING
  answers_count > 5;

#
# 4. Get all the answers for a given questionnaire in the last month
#
SELECT
  ra.*, qao.answer_value
FROM
  questionnaire qr
    INNER JOIN questionnaire_questions qq
               ON qr.id = qq.qr_id
    INNER JOIN questions qn
               ON qq.qn_id = qn.id
    INNER JOIN questions_answer_options qao
               ON qn.id = qao.qn_id
    INNER JOIN responders_answers ra
               ON qao.id = ra.an_id
WHERE
  ra.datetime_added BETWEEN
    /* Greater or equal to the start of last month */
    DATE_ADD(LAST_DAY(DATE_SUB(NOW(), INTERVAL 2 MONTH)), INTERVAL 1 DAY)
    AND
    /* Smaller or equal than one month ago */
    LAST_DAY(DATE_SUB(NOW(), INTERVAL 1 MONTH)) AND qr_id = 1;

#
# 5. Get all the questionnaires that were answered the most in the last month
#
SELECT
  qr.*,
  COUNT(ra.id) AS answers_count
FROM
  questionnaire qr
    INNER JOIN questionnaire_questions qq
               ON qr.id = qq.qr_id
    INNER JOIN questions qn
               ON qq.qn_id = qn.id
    INNER JOIN questions_answer_options qao
               ON qn.id = qao.qn_id
    INNER JOIN responders_answers ra
               ON qao.id = ra.an_id
WHERE
  ra.datetime_added BETWEEN
    /* Greater or equal to the start of last month */
    DATE_ADD(LAST_DAY(DATE_SUB(NOW(), INTERVAL 2 MONTH)), INTERVAL 1 DAY) AND
    /* Smaller or equal than one month ago */
    LAST_DAY(DATE_SUB(NOW(), INTERVAL 1 MONTH))
GROUP BY
  qr.id
ORDER BY
  answers_count DESC;

#
# 6. Get the min, max and average for every question in the last month (3 queries)
#
# Note: The assumption here is that we want to check the min, max and avg in terms of *value* or the answer.
#       That obviously makes sense for numeric answers (eg. range 1 to 10) but it's doubtful whether this is
#       of any value for answers like "Yes", "No" etc. We would need to redefine and discuss the requirement here!
#
SELECT
  qn_id,
  COUNT(ra.id) AS answers_count,
  MIN(qao.answer_value),
  MAX(qao.answer_value),
  AVG(qao.answer_value)
FROM
  questions_answer_options qao
    INNER JOIN responders_answers ra
               ON qao.id = ra.an_id
WHERE
  ra.datetime_added BETWEEN
    /* Greater or equal to the start of last month */
    DATE_ADD(LAST_DAY(DATE_SUB(NOW(), INTERVAL 2 MONTH)), INTERVAL 1 DAY) AND
    /* Smaller or equal than one month ago */
    LAST_DAY(DATE_SUB(NOW(), INTERVAL 1 MONTH))
GROUP BY
  qn_id;

