CREATE TABLE questionnaire (
    id    INT AUTO_INCREMENT,
    title VARCHAR(512) NOT NULL COMMENT 'Title of Questionnaire',
    CONSTRAINT questionaire_id_uindex
        UNIQUE (id)
)
    COMMENT 'Questionnaire definition';

ALTER TABLE questionnaire
    ADD PRIMARY KEY (id);

CREATE TABLE questionnaire_metadata (
    id             INT AUTO_INCREMENT,
    qr_id          INT          NOT NULL,
    metadata_key   VARCHAR(512) NOT NULL,
    metadata_value TEXT         NOT NULL,
    CONSTRAINT questionnaire_metadata_id_uindex
        UNIQUE (id),
    CONSTRAINT questionnaire_metadata_questionaire_id_fk
        FOREIGN KEY (qr_id) REFERENCES questionnaire(id)
            ON UPDATE CASCADE ON DELETE CASCADE
)
    COMMENT 'Metadata to be linked to a questionnaire';

ALTER TABLE questionnaire_metadata
    ADD PRIMARY KEY (id);

CREATE TABLE questions (
    id   INT AUTO_INCREMENT,
    text TEXT NOT NULL,
    CONSTRAINT questions_id_uindex
        UNIQUE (id)
)
    COMMENT 'Questions definition';

ALTER TABLE questions
    ADD PRIMARY KEY (id);

CREATE TABLE questionnaire_questions (
    id    INT AUTO_INCREMENT,
    qr_id INT NOT NULL,
    qn_id INT NOT NULL,
    CONSTRAINT questionaire_questions_id_uindex
        UNIQUE (id),
    CONSTRAINT questionaire_questions_questionaire_id_fk
        FOREIGN KEY (qr_id) REFERENCES questionnaire(id)
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT questionaire_questions_questions_id_fk
        FOREIGN KEY (qn_id) REFERENCES questions(id)
            ON UPDATE CASCADE ON DELETE CASCADE
)
    COMMENT 'Questionnaire to Questions relationship (1:N)';

ALTER TABLE questionnaire_questions
    ADD PRIMARY KEY (id);

CREATE TABLE questions_answer_options (
    id           INT AUTO_INCREMENT,
    qn_id        INT          NOT NULL,
    answer_value VARCHAR(512) NOT NULL COMMENT 'Value of answer presented to the responder. eg. "Yes", "No", "1", "2", etc.',
    CONSTRAINT questions_answers_id_uindex
        UNIQUE (id),
    CONSTRAINT questions_answers_qn_id_answer_value_uindex
        UNIQUE (qn_id, answer_value),
    CONSTRAINT questions_answers_questions_id_fk
        FOREIGN KEY (qn_id) REFERENCES questions(id)
            ON UPDATE CASCADE ON DELETE CASCADE
)
    COMMENT 'Possible answers (options) to questions.';

ALTER TABLE questions_answer_options
    ADD PRIMARY KEY (id);

CREATE TABLE responders (
    id    INT AUTO_INCREMENT,
    email VARCHAR(256) CHARSET utf8 NOT NULL COMMENT 'The email of the responder. Can be used to identify them.',
    CONSTRAINT responders_email_uindex
        UNIQUE (email),
    CONSTRAINT responders_id_uindex
        UNIQUE (id)
)
    COMMENT 'Users that respond to questionnaires';

ALTER TABLE responders
    ADD PRIMARY KEY (id);

CREATE TABLE responders_answers (
    id             INT AUTO_INCREMENT,
    rs_id          INT      NOT NULL,
    an_id          INT      NOT NULL,
    datetime_added DATETIME NULL COMMENT 'Datetime that the responder answered the question',
    CONSTRAINT responders_answers_id_uindex
        UNIQUE (id),
    CONSTRAINT responders_answers_questions_answers_id_fk
        FOREIGN KEY (an_id) REFERENCES questions_answer_options(id)
            ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT responders_answers_responders_id_fk
        FOREIGN KEY (rs_id) REFERENCES responders(id)
            ON UPDATE CASCADE ON DELETE CASCADE
)
    COMMENT 'Responder to answer relation table. (0:1)';

ALTER TABLE responders_answers
    ADD PRIMARY KEY (id);

