drop table if exists courses_jt;
create json collection table courses_jt;
drop table if exists students_jt;
create json collection table students_jt;
drop table if exists teachers_jt;
create json collection table teachers_jt;
insert into students_jt(data) values(trim(q'~
{"studentId" : 1,
 "name"      : "Donald P.",
 "age"       : 20,
 "courses"   : [ {"courseNumber" : "MATH101",
                  "name"         : "Algebra",
                  "grade"        : 90},
                 {"courseNumber" : "CS101",
                  "name"         : "Algorithms",
                  "grade"        : 90},
                 {"courseNumber" : "CS102",
                  "name"         : "Data Structures",
                  "grade"        : "TBD"} ]}
~'));
insert into students_jt(data) values(trim(q'~
{"studentId" : 2,
 "name"      : "Elena H.",
 "age"       : 21,
 "courses"   : [ {"courseNumber" : "MATH102",
                  "name"         : "Calculus",
                  "grade"        : 95},
                 {"courseNumber" : "CS101",
                  "name"         : "Algorithms",
                  "grade"        : 75},
                 {"courseNumber" : "CS102",
                  "name"         : "Data Structures",
                  "grade"        : "TBD"} ]}
~'));
insert into students_jt(data) values(trim(q'~
{"studentId" : 3,
 "name"      : "Francis K.",
 "age"       : 20,
 "courses"   : [ {"courseNumber" : "MATH103",
                  "name"         : "Advanced Algebra",
                  "grade"        : 83} ]}
~'));
insert into students_jt(data) values(trim(q'~
{"studentId" : 4,
 "name"      : "Georgia D.",
 "age"       : 19,
 "courses"   : [ {"courseNumber" : "MATH102",
                  "name"         : "Calculus",
                  "grade"        : 85},
                 {"courseNumber" : "CS101",
                  "name"         : "Algorithms",
                  "grade"        : 75},
                 {"courseNumber" : "MATH103",
                  "name"         : "Advanced Algebra",
                  "grade"        : 82} ]}
~'));
insert into students_jt(data) values(trim(q'~
{"studentId" : 5,
 "name"      : "Hye E.",
 "age"       : 21,
 "courses"   : [ {"courseNumber" : "MATH101",
                  "name"         : "Algebra",
                  "grade"        : 97},
                 {"courseNumber" : "CS102",
                  "name"         : "Data Structures",
                  "grade"        : "TBD"} ]}
~'));
insert into students_jt(data) values(trim(q'~
{"studentId" : 6,
 "name"      : "Ileana D.",
 "age"       : 21,
 "courses"   : [ {"courseNumber" : "MATH103",
                  "name"         : "Advanced Algebra",
                  "grade"        : 95}]}
~'));
insert into students_jt(data) values(trim(q'~
{"studentId" : 7,
 "name"      : "Jatin S.",
 "age"       : 20,
 "courses"   : [ {"courseNumber" : "CS101",
                  "name"         : "Algorithms",
                  "grade"        : 85},
                 {"courseNumber" : "CS102",
                  "name"         : "Data Structures",
                  "grade"        : "TBD"} ]}
~'));
insert into students_jt(data) values(trim(q'~
{"studentId" : 8,
 "name"      : "Katie H.",
 "age"       : 21,
 "courses"   : [ {"courseNumber" : "MATH103",
                  "name"         : "Advanced Algebra",
                  "grade"        : 90},
                 {"courseNumber" : "CS102",
                  "name"         : "Data Structures",
                  "grade"        : "TBD"} ]}
~'));
insert into students_jt(data) values(trim(q'~
{"studentId" : 9,
 "name"      : "Luis F.",
 "age"       : 19,
 "courses"   : [ {"courseNumber" : "MATH102",
                  "name"         : "Calculus",
                  "grade"        : 95},
                 {"courseNumber" : "CS101",
                  "name"         : "Algorithms",
                  "grade"        : 75},
                 {"courseNumber" : "MATH103",
                  "name"         : "Advanced Algebra",
                  "grade"        : 85} ]}
~'));
insert into students_jt(data) values(trim(q'~
{"studentId" : 10,
 "name"      : "Ming L.",
 "age"       : 20,
 "courses"   : [ {"courseNumber" : "MATH102",
                  "name"         : "Calculus",
                  "grade"        : 95} ]}
~'));
insert into teachers_jt(data) values (trim(q'~
{"_id"           : 101,
 "name"          : "Abdul J.",
 "phoneNumber"   : [ "222-555-011", "222-555-012" ],
 "salary"        : 200000,
 "department"    : "Mathematics",
 "coursesTaught" : [ {"courseId"  : "MATH101",
                      "name"      : "Algebra",
                      "classType" : "Online"},
                     {"courseId"  : "MATH102",
                      "name"      : "Calculus",
                      "classType" : "In-person"} ]}
~'));
insert into teachers_jt(data) values (trim(q'~
{"_id"           : 102,
 "name"          : "Betty Z.",
 "phoneNumber"   : "222-555-022",
 "salary"        : 300000,
 "department"    : "Computer Science",
 "coursesTaught" : [ {"courseId"  : "CS101",
                      "name"      : "Algorithms",
                      "classType" : "Online"},
                     {"courseId"  : "CS102",
                      "name"      : "Data Structures",
                      "classType" : "In-person"} ]}
  ~'));
insert into teachers_jt(data) values (trim(q'~
{"_id"           : 103,
 "name"          : "Colin J.",
 "phoneNumber"   : [ "222-555-023" ],
 "salary"        : 220000,
 "department"    : "Mathematics",
 "coursesTaught" : [ {"courseId"  : "MATH103",
                      "name"      : "Advanced Algebra",
                      "classType" : "Online"} ]}
  ~'));
insert into teachers_jt(data) values (trim(q'~
{"_id"           : 104,
 "name"          : "Natalie C.",
 "phoneNumber"   : "222-555-044",
 "salary"        : 180000,
 "department"    : "Computer Science",
 "coursesTaught" : []}
 ~'));
insert into courses_jt(data) values(trim(q'~
{"courseId"         : "MATH101",
 "name"             : "Algebra",
 "creditHours"      : 3,
 "students"         : [ {"studentId" : 1, "name" : "Donald P."},
                        {"studentId" : 5, "name" : "Hye E."} ],
 "teacher"          : {"teacherId" : 101, "name" : "Abdul J."},
 "Notes"            : "Prerequisite for Advanced Algebra"}
 ~'));
insert into courses_jt(data) values(trim(q'~
{"courseId"         : "MATH102",
 "name"             : "Calculus",
 "creditHours"      : 4,
 "students"         : [ {"studentId" : 2,  "name" : "Elena H."},
                        {"studentId" : 10, "name" : "Ming L."},
                        {"studentId" : 9,  "name" : "Luis F."},
                        {"studentId" : 4,  "name" : "Georgia D."} ],
 "teacher"          : {"teacherId" : 101,  "name" : "Abdul J."}}
 ~'));
insert into courses_jt(data) values(trim(q'~
{"courseId"         : "CS101",
 "name"             : "Algorithms",
 "creditHours"      : 5,
 "students"         : [ {"studentId" : 1, "name" : "Donald P."},
                        {"studentId" : 2, "name" : "Elena H."},
                        {"studentId" : 4, "name" : "Georgia D."},
                        {"studentId" : 9, "name" : "Luis F."},
                        {"studentId" : 7, "name" : "Jatin S."} ],
 "teacher"          : {"teacherId" : 102, "name" : "Betty Z."}}
 ~'));
insert into courses_jt(data) values(trim(q'~
{"courseId"         : "CS102",
 "name"             : "Data Structures",
 "creditHours"      : 3,
 "students"         : [ {"studentId" : 1, "name" : "Donald P."},
                        {"studentId" : 2, "name" : "Elena H."},
                        {"studentId" : 5, "name" : "Hye E."},
                        {"studentId" : 7, "name" : "Jatin S."},
                        {"studentId" : 8, "name" : "Katie H."} ],
 "teacher"          : {"teacherId" : 102, "name" : "Betty Z."}}
 ~'));
insert into courses_jt(data) values(trim(q'~
{"courseId"         : "MATH103",
 "name"             : "Advanced Algebra",
 "creditHours"      : "3",
 "students"         : [ {"studentId" : 3, "name" : "Francis K."},
                        {"studentId" : 4, "name" : "Georgia D."},
                        {"studentId" : 8, "name" : "Katie H."},
                        {"studentId" : 9, "name" : "Luis F."},
                        {"studentId" : 6, "name" : "Ileana D."} ],
 "teacher"          : {"teacherId" : 103, "name" : "Colin J."}}
 ~'));
commit;
