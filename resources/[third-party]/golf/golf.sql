CREATE TABLE `golfhits` (
  `identifier` varchar(60) NOT NULL,
  `name` text NOT NULL,
  `distance` float NOT NULL,
  `date` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `golfhits`
  ADD PRIMARY KEY (`identifier`);