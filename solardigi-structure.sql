SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `aprs`
--
CREATE DATABASE IF NOT EXISTS `aprs` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `aprs`;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `packet`
--

CREATE TABLE `packet` (
  `id` int(11) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT current_timestamp(),
  `callsign` varchar(10) NOT NULL,
  `dest` varchar(10) NOT NULL,
  `comment` varchar(255) DEFAULT '0',
  `lat` float DEFAULT 0,
  `lon` float DEFAULT 0,
  `type` text NOT NULL,
  `raw` varchar(255) NOT NULL,
  `symboltable` varchar(1) DEFAULT '0',
  `symbolcode` varchar(1) DEFAULT '0',
  `digipeated` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `telemetry`
--

CREATE TABLE `telemetry` (
  `id` int(11) NOT NULL,
  `datetime` timestamp NOT NULL DEFAULT current_timestamp(),
  `callsign` varchar(12) NOT NULL,
  `seq` int(11) NOT NULL,
  `ch0raw` float NOT NULL,
  `ch1raw` float NOT NULL,
  `ch2raw` float NOT NULL,
  `ch3raw` float NOT NULL,
  `ch4raw` float NOT NULL,
  `bits` varchar(11) NOT NULL,
  `raw` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `packet`
--
ALTER TABLE `packet`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `telemetry`
--
ALTER TABLE `telemetry`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `packet`
--
ALTER TABLE `packet`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `telemetry`
--
ALTER TABLE `telemetry`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
