Option Explicit

Dim args, folderPath, baseFilePath
Dim fso, folder, file
Dim wordApp, mainDoc, rng, firstPageRange
Dim mergedFilePath

Set args = WScript.Arguments
If args.Count < 2 Then
    WScript.Echo "Не передано аргументи: папка та Base.docx"
    WScript.Quit 1
End If

folderPath = args(0)
baseFilePath = args(1)

Set fso = CreateObject("Scripting.FileSystemObject")
If Not fso.FolderExists(folderPath) Then
    WScript.Echo "Папка не існує"
    WScript.Quit 1
End If

If Not fso.FileExists(baseFilePath) Then
    WScript.Echo "Base.docx не знайдено: " & baseFilePath
    WScript.Quit 1
End If

mergedFilePath = folderPath & "\Merged.docx"
' Видаляємо старий Merged.docx, якщо існує
If fso.FileExists(mergedFilePath) Then
    fso.DeleteFile mergedFilePath, True
End If

Set folder = fso.GetFolder(folderPath)

' Запускаємо Word
Set wordApp = CreateObject("Word.Application")
wordApp.Visible = False

' Відкриваємо Base.docx
Set mainDoc = wordApp.Documents.Open(baseFilePath)

' Вставляємо всі інші файли
For Each file In folder.Files
    If LCase(fso.GetExtensionName(file.Name)) = "docx" And _
       Left(file.Name,2) <> "~$" And _
       LCase(file.Name) <> LCase(fso.GetFileName(baseFilePath)) Then

        Set rng = mainDoc.Content
        rng.Collapse 0 ' End of document
        rng.InsertFile file.Path, , , False, True
        rng.InsertBreak 7 ' PageBreak
        WScript.Sleep 300
    End If
Next

' Видаляємо першу сторінку Base.docx, якщо хочемо
Set firstPageRange = mainDoc.GoTo(1,1)
firstPageRange.End = mainDoc.GoTo(2,1).Start
firstPageRange.Delete

' Зберігаємо результат
mainDoc.SaveAs2 mergedFilePath
mainDoc.Close False
wordApp.Quit

WScript.Echo "Об’єднання завершено!"
