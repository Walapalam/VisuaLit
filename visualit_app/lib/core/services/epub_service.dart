// lib/services/epub_service.dart
import 'dart:io' as io;
import 'package:epubx/epubx.dart';
import 'package:path/path.dart' as path;
import 'package:visualit_app/core/models/book.dart';

class EpubService {
  Future<Book> createBookFromEpub(String filePath) async {
    // Get the EPUB into memory
    var targetFile = io.File(filePath);
    List<int> bytes = await targetFile.readAsBytes();

    // Opens a book and reads all of its content into memory
    EpubBook epubBook = await EpubReader.readBook(bytes);

    // Extract metadata and content
    String? title = epubBook.Title;
    String? author = epubBook.Author;
    List<String?>? authors = epubBook.AuthorList;
    Image? coverImage = epubBook.CoverImage;

    List<Chapter> chapters = epubBook.Chapters!.map((EpubChapter chapter) {
      return Chapter(
        title: chapter.Title??"",
        htmlContent: chapter.HtmlContent??"",
        subChapters: chapter.SubChapters!.map((subChapter) {
          return Chapter(
            title: subChapter.Title??"",
            htmlContent: subChapter.HtmlContent??"",
            subChapters: [],
          );
        }).toList(),
      );
    }).toList();

    Map<String, EpubByteContentFile>? images = epubBook.Content?.Images;
    Map<String, EpubTextContentFile>? htmlFiles = epubBook.Content?.Html;
    Map<String, EpubTextContentFile>? cssFiles = epubBook.Content?.Css;
    Map<String, EpubByteContentFile>? fonts = epubBook.Content?.Fonts;
    Map<String, EpubContentFile>? allFiles = epubBook.Content?.AllFiles;

    List<Contributor> contributors = epubBook.Schema!.Package!.Metadata!.Contributors!.map((contributor) {
      return Contributor(
        name: contributor.Contributor??"",
        role: contributor.Role??"",
      );
    }).toList();

    List<Metadata> metadata = epubBook.Schema!.Navigation!.Head!.Metadata!.map((meta) {
      return Metadata(
        name: meta.Name??"",
        content: meta.Content??"",
      );
    }).toList();

    // Create and return the Book model
    return Book(
      title: title??"",
      author: author??"",
      authors: authors?.whereType<String>().toList() ?? [],
      coverImage: coverImage,
      chapters: chapters,
      images: images??{},
      htmlFiles: htmlFiles??{},
      cssFiles: cssFiles??{},
      fonts: fonts??{},
      allFiles: allFiles??{},
      contributors: contributors,
      metadata: metadata,
    );
  }
}