package com.conky.musicplayer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Periodically deletes any downloaded album art that has not been loaded
 * by the media player conky in a given amount of time.
 */
public class AlbumArtHouseKeeper implements Runnable {
    private static Logger logger = LoggerFactory.getLogger(AlbumArtHouseKeeper.class);
    private String directory;
    private int threshold;

    /**
     * Creates a new instance of this album housekeeper thread
     * @param directory directory where album art is stored
     * @param threshold cutoff in minutes to determine old files
     */
    public AlbumArtHouseKeeper(String directory, int threshold) {
        this.directory = directory;
        this.threshold = threshold;
    }

    @Override
    public void run() {
        logger.debug("deleting old album art");
        Instant now = Instant.now();

        try {
            List<Path> files = Files.list(Paths.get(directory))
                                    .filter(p -> p.getFileName().toString().startsWith(TrackUpdatesHandler.FILE_PREFIX + "."))
                                    .collect(Collectors.toList());
            files.stream()
                    .forEach(f -> {
                        try {
                            BasicFileAttributes attributes = Files.readAttributes(f, BasicFileAttributes.class);
                            Instant lastAccessTime = attributes.lastAccessTime().toInstant();
                            long minutes = Duration.between(lastAccessTime, now).toMinutes();

                            if (minutes > threshold) {
                                logger.info("deleting file: {}", f.getFileName());
                                logger.debug("last access time was: {}", lastAccessTime);
                                Files.deleteIfExists(f);
                            }
                        } catch (IOException e) {
                            logger.error("unable to delete image file", e);
                        }
                    });
        } catch (IOException e) {
            logger.error("unable to iterate through the output folder for old image files", e);
        }
    }
}
