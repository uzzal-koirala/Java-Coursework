use gunaso_db;

DELETE FROM users WHERE email IN ('pm@gov.np', 'wada7@gov.np', 'mayor@gov.np');

-- Salt and Hash for 'Password123' is: rFBwU/Emtb+F2+YYGvS1Rw==:CIjtdaoNMGkDRc1C7c6VT+7K9jC55Xn9pnhC1+DKGYE=

INSERT INTO users (full_name, email, password, phone, role_id, dept_id, status, verification_status)
VALUES ('Pushpa Kamal Dahal', 'pm@gov.np', 'rFBwU/Emtb+F2+YYGvS1Rw==:CIjtdaoNMGkDRc1C7c6VT+7K9jC55Xn9pnhC1+DKGYE=', '9876543201', 4, NULL, 'Active', 'Verified');

INSERT INTO users (full_name, email, password, phone, role_id, dept_id, status, verification_status)
VALUES ('Ram Bahadur Thapa', 'wada7@gov.np', 'rFBwU/Emtb+F2+YYGvS1Rw==:CIjtdaoNMGkDRc1C7c6VT+7K9jC55Xn9pnhC1+DKGYE=', '9876543202', 2, 6, 'Active', 'Verified');

INSERT INTO users (full_name, email, password, phone, role_id, dept_id, status, verification_status)
VALUES ('Mayor Balendra Shah', 'mayor@gov.np', 'rFBwU/Emtb+F2+YYGvS1Rw==:CIjtdaoNMGkDRc1C7c6VT+7K9jC55Xn9pnhC1+DKGYE=', '9876543203', 3, 3, 'Active', 'Verified');
