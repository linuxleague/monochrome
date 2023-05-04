package com.conky.musicplayer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.file.*;

import static com.conky.musicplayer.MusicPlayerWriter.ALBUM_ART;

/**
 * Runnable task to download album art from the web
 */
public class ImageDownloader implements Runnable {
    private static final Logger logger = LoggerFactory.getLogger(ImageDownloader.class);
    private String url;
    private final String outputDirectory;
    private Path albumArtPath;

    /**
     * Create a new instance of this image download task
     *
     * @param outDir       output directory
     * @param url          URL of the image to download, ex. <tt>https://i.scdn.co/image/ab67616d0000b</tt>
     * @param albumArtPath target file path on disk of the image to be downloaded
     */
    public ImageDownloader(String outDir, String url, Path albumArtPath) {
        this.url = url;
        outputDirectory = outDir;
        this.albumArtPath = albumArtPath;
    }

    @Override
    public void run() {
        if (Files.exists(albumArtPath, LinkOption.NOFOLLOW_LINKS)) {
            logger.info("album art {} is already available on disk, no need to download it again from the web", albumArtPath);
            return;
        }

        try {
            // album art is downloaded to a temporary file and then renamed to the actual file name
            // this is to prevent conky from loading an incomplete image
            ReadableByteChannel readableByteChannel = Channels.newChannel(new URL(url).openStream());
            Path tempFile = Paths.get(outputDirectory, ALBUM_ART + ".temp");
            FileOutputStream fileOutputStream = new FileOutputStream(tempFile.toFile());
            fileOutputStream.getChannel().transferFrom(readableByteChannel, 0, Long.MAX_VALUE);
            fileOutputStream.close();
            Files.move(tempFile, albumArtPath, StandardCopyOption.REPLACE_EXISTING);
            logger.info("saved album art to disk: {}", albumArtPath);
        } catch (IOException e) {
            logger.error("unable to download album art from the web", e);
        }
    }
}