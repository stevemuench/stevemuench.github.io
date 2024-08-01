drop table if exists courses_jt;
create json collection table courses_jt;
drop table if exists students_jt;
create json collection table students_jt;
drop table if exists teachers_jt;
create json collection table teachers_jt;
insert into courses_jt(data) values (q'~{
    "courseCode": "CAN201",
    "description": "Complex Analysis 201",
    "offerings": [
        {
            "semester": "Fall",
            "year": 2023,
            "teacher": {
                "firstName": "Tina",
                "lastName": "Tomlin"
            },
            "enrolledStudents": [
                {
                    "studentId": 11111,
                    "firstName": "Albert",
                    "lastName": "Ardle"
                },
                {
                    "studentId": 33333,
                    "firstName": "Charlie",
                    "lastName": "Cooper"
                }
            ]
        },
        {
            "semester": "Spring",
            "year": 2024,
            "teacher": {
                "firstName": "Tina",
                "lastName": "Tomlin"
            },
            "enrolledStudents": [
                {
                    "studentId": 22222,
                    "firstName": "Ben",
                    "lastName": "Brooke"
                },
                {
                    "studentId": 44444,
                    "firstName": "Deena",
                    "lastName": "Dunne"
                }
            ]
        }
    ]
}~');
insert into courses_jt(data) values (q'~{
    "courseCode": "PYT25",
    "description": "Python Programming 25",
    "offerings": [
        {
            "semester": "Fall",
            "year": 2023,
            "teacher": {
                "firstName": "Tony",
                "lastName": "Tapp"
            },
            "enrolledStudents": [
                {
                    "studentId": 11111,
                    "firstName": "Albert",
                    "lastName": "Ardle"
                },
                {
                    "studentId": 44444,
                    "firstName": "Deena",
                    "lastName": "Dunne"
                },
                {
                    "studentId": 33333,
                    "firstName": "Charlie",
                    "lastName": "Cooper"
                }
            ]
        },
        {
            "semester": "Spring",
            "year": 2024,
            "teacher": {
                "firstName": "Tina",
                "lastName": "Tomlin"
            },
            "enrolledStudents": [
                {
                    "studentId": 22222,
                    "firstName": "Ben",
                    "lastName": "Brooke"
                }
            ]
        }
    ]
}~');
insert into courses_jt(data) values (q'~{
    "courseCode": "ALG10",
    "description": "Algebra 10",
    "offerings": [
        {
            "semester": "Fall",
            "year": 2023,
            "teacher": {
                "firstName": "Tony",
                "lastName": "Tapp"
            },
            "enrolledStudents": [
                {
                    "studentId": 11111,
                    "firstName": "Albert",
                    "lastName": "Ardle"
                },
                {
                    "studentId": 22222,
                    "firstName": "Ben",
                    "lastName": "Brooke"
                }
            ]
        },
        {
            "semester": "Spring",
            "year": 2024,
            "teacher": {
                "firstName": "Tony",
                "lastName": "Tapp"
            },
            "enrolledStudents": [
                {
                    "studentId": 33333,
                    "firstName": "Charlie",
                    "lastName": "Cooper"
                },
                {
                    "studentId": 44444,
                    "firstName": "Deena",
                    "lastName": "Dunne"
                }
            ]
        }
    ]
}~');
insert into students_jt(data) values (q'~{
    "studentId": 11111,
    "firstName": "Albert",
    "lastName": "Ardle",
    "coursesTaken": [
        {
            "courseCode": "CAN201",
            "semester": "Fall",
            "year": 2023
        },
        {
            "courseCode": "PYT25",
            "semester": "Fall",
            "year": 2023
        },
        {
            "courseCode": "ALG10",
            "semester": "Fall",
            "year": 2023
        }
    ]
}~');
insert into students_jt(data) values (q'~{
    "studentId": 22222,
    "firstName": "Ben",
    "lastName": "Brooke",
    "coursesTaken": [
        {
            "courseCode": "CAN201",
            "semester": "Spring",
            "year": 2024
        },
        {
            "courseCode": "PYT25",
            "semester": "Spring",
            "year": 2024
        },
        {
            "courseCode": "ALG10",
            "semester": "Fall",
            "year": 2023
        }
    ]
}~');
insert into students_jt(data) values (q'~{
    "studentId": 33333,
    "firstName": "Charlie",
    "lastName": "Cooper",
    "coursesTaken": [
        {
            "courseCode": "CAN201",
            "semester": "Fall",
            "year": 2023
        },
        {
            "courseCode": "PYT25",
            "semester": "Fall",
            "year": 2023
        },
        {
            "courseCode": "ALG10",
            "semester": "Spring",
            "year": 2024
        }
    ]
}~');
insert into students_jt(data) values (q'~{
    "studentId": 44444,
    "firstName": "Deena",
    "lastName": "Dunne",
    "coursesTaken": [
        {
            "courseCode": "CAN201",
            "semester": "Spring",
            "year": 2024
        },
        {
            "courseCode": "PYT25",
            "semester": "Fall",
            "year": 2023
        },
        {
            "courseCode": "ALG10",
            "semester": "Spring",
            "year": 2024
        }
    ]
}~');
insert into teachers_jt(data) values (q'~{
    "firstName": "Tina",
    "lastName": "Tomlin",
    "coursesTaught": [
        {
            "courseCode": "CAN201",
            "semester": "Fall",
            "year": 2023
        },
        {
            "courseCode": "CAN201",
            "semester": "Spring",
            "year": 2024
        },
        {
            "courseCode": "PYT25",
            "semester": "Spring",
            "year": 2024
        }
    ]
}~');
insert into teachers_jt(data) values (q'~{
    "firstName": "Tony",
    "lastName": "Tapp",
    "coursesTaught": [
        {
            "courseCode": "ALG10",
            "semester": "Fall",
            "year": 2023
        },
        {
            "courseCode": "ALG10",
            "semester": "Spring",
            "year": 2024
        },
        {
            "courseCode": "PYT25",
            "semester": "Fall",
            "year": 2023
        }
    ]
}~');
commit;
