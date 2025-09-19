Option Explicit

Dim args, folderPath, baseFilePath
Dim fso, folder, file
Dim wordApp, mainDoc, rng, firstPageRange
Dim mergedFilePath
Dim total, counter

Set args = WScript.Arguments
If args.Count < 2 Then
    WScript.Echo "ERROR: Не передано аргументи"
    WScript.Quit 1
End If

folderPath = args(0)
baseFilePath = args(1)

Set fso = CreateObject("Scripting.FileSystemObject")
If Not fso.FolderExists(folderPath) Then
    WScript.Echo "ERROR: Папка не існує"
    WScript.Quit 1
End If

If Not fso.FileExists(baseFilePath) Then
    WScript.Echo "ERROR: Base.docx не знайдено"
    WScript.Quit 1
End If

mergedFilePath = folderPath & "\Merged.docx"
If fso.FileExists(mergedFilePath) Then
    fso.DeleteFile mergedFilePath, True
End If

Set folder = fso.GetFolder(folderPath)

' Підрахунок файлів
total = 0
For Each file In folder.Files
    If LCase(fso.GetExtensionName(file.Name)) = "docx" And _
       Left(file.Name,2) <> "~$" And _
       LCase(file.Name) <> LCase(fso.GetFileName(baseFilePath)) Then
        total = total + 1
    End If
Next

' Запускаємо Word
Set wordApp = CreateObject("Word.Application")
wordApp.Visible = False
Set mainDoc = wordApp.Documents.Open(baseFilePath)

counter = 0

For Each file In folder.Files
    If LCase(fso.GetExtensionName(file.Name)) = "docx" And _
       Left(file.Name,2) <> "~$" And _
       LCase(file.Name) <> LCase(fso.GetFileName(baseFilePath)) Then

    ' Вставка файлу
        Set rng = mainDoc.Content
        rng.Collapse 0
        rng.InsertFile file.Path, , , False, True

        ' Створюємо Range в кінці вставленого фрагменту
        Set rng = mainDoc.Content
        rng.Collapse 0
        counter = counter + 1
        WScript.Echo "PROGRESS:" & Int((counter/total)*100)
    End If
Next

' Видалення першої сторінки (як у вас було)
Set firstPageRange = mainDoc.GoTo(1,1)
firstPageRange.End = mainDoc.GoTo(2,1).Start
firstPageRange.Delete

mainDoc.SaveAs2 mergedFilePath
mainDoc.Close False
wordApp.Quit

WScript.Echo "Об’єднання завершено!"
