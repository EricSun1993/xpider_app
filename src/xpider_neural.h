#ifndef XPIDER_NEURAL_H
#define XPIDER_NEURAL_H

#include <QObject>

class XpiderNeural : public QObject
{
  Q_OBJECT
private:
  static const QString kNNDataFileName;
  static const QString kGroupDataFileName;

  QString file_path_;
  QString nn_file_path;
  QString group_file_path;
public:
  explicit XpiderNeural(QObject *parent = nullptr);

  void SetFilePath(QString);

  bool LoadNNData();
  bool SaveNNData();

  QByteArray LoadGroupData();
  bool SaveGroupData(QByteArray);
};

#endif // XPIDER_NEURAL_H
