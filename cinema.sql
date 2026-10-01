create table films
(
    id               bigint auto_increment
        primary key,
    title            varchar(255)                          not null,
    description      text                                  null,
    duration_minutes int                                   not null,
    release_date     date                                  null,
    age_rating       varchar(20)                           null,
    director         varchar(255)                          null,
    created_at       timestamp default current_timestamp() not null,
    constraint chk_film_duration
        check (`duration_minutes` > 0)
);

create table halls
(
    id       bigint auto_increment
        primary key,
    name     varchar(100) not null,
    capacity int          not null,
    constraint name
        unique (name),
    constraint chk_hall_capacity
        check (`capacity` > 0)
);

create table news
(
    id           bigint auto_increment
        primary key,
    title        varchar(255)                          not null,
    content      text                                  not null,
    published_at timestamp                             null,
    created_at   timestamp default current_timestamp() not null
);

create table screenings
(
    id        bigint auto_increment
        primary key,
    film_id   bigint        not null,
    hall_id   bigint        not null,
    starts_at timestamp     not null,
    ends_at   timestamp     not null,
    price     decimal(8, 2) not null,
    constraint fk_screenings_film
        foreign key (film_id) references films (id),
    constraint fk_screenings_hall
        foreign key (hall_id) references halls (id),
    constraint chk_screening_price
        check (`price` >= 0),
    constraint chk_screening_time
        check (`ends_at` > `starts_at`)
);

create table users
(
    id            bigint auto_increment
        primary key,
    first_name    varchar(100)                          not null,
    last_name     varchar(100)                          not null,
    email         varchar(255)                          not null,
    password_hash varchar(255)                          not null,
    date_of_birth date                                  null,
    created_at    timestamp default current_timestamp() not null,
    constraint email
        unique (email)
);

create table bookings
(
    id           bigint auto_increment
        primary key,
    user_id      bigint                                  not null,
    screening_id bigint                                  not null,
    booked_at    timestamp   default current_timestamp() not null,
    status       varchar(30) default 'confirmed'         not null,
    constraint fk_bookings_screening
        foreign key (screening_id) references screenings (id),
    constraint fk_bookings_user
        foreign key (user_id) references users (id),
    constraint chk_booking_status
        check (`status` in ('pending', 'confirmed', 'cancelled'))
);

create table reviews
(
    id         bigint auto_increment
        primary key,
    user_id    bigint                                not null,
    film_id    bigint                                not null,
    rating     int                                   not null,
    comment    text                                  null,
    created_at timestamp default current_timestamp() not null,
    constraint uq_user_film_review
        unique (user_id, film_id),
    constraint fk_reviews_film
        foreign key (film_id) references films (id)
            on delete cascade,
    constraint fk_reviews_user
        foreign key (user_id) references users (id)
            on delete cascade,
    constraint chk_review_rating
        check (`rating` between 1 and 5)
);


