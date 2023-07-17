import UIKit
import Kingfisher



class ViewController: UIViewController {
    @IBOutlet weak var imagecollectioView : UICollectionView!
    var ImageModel = imageviewmode()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        Constant.shared.page = 1
        configuratio()
        imagecollectioView.register(UINib(nibName: "Imagecell", bundle: nil), forCellWithReuseIdentifier: "Imagecell")
    }
    func configuratio () {
        callApifunc()
        Eventcaller()
        
    }
    func callApifunc () {
        ImageModel.fatchimage()
    }
    func Eventcaller () {
        ImageModel.Event = {[weak self] event in
            guard self != nil else {
                return
            }
            switch event {
            case .loading:
                print("Loading")
            case.Getdata:
                DispatchQueue.main.async {
                    self?.imagecollectioView.reloadData()
                }
                print("Getdata")
            case.stoploading:
                print("Loadingcompleted")
            case.error(_error: let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.shared.Finalresult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Imagecell", for: indexPath) as! Imagecell
        
        let result = Constant.shared.Finalresult[indexPath.row]
        let url = result.urls
        let Url =  url?.full
        let Imageurl = URL(string: Url!)
        let processor = DownsamplingImageProcessor(size: cell.imgview.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 15)
        cell.imgview.kf.indicatorType = .activity
        cell.imgview.kf.setImage(
            with: Imageurl,
          //  placeholder: UIImage(named: ""),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        return cell
    }
}
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.width/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
       
        if indexPath.row == Constant.shared.Finalresult.count-1 {
            Constant.shared.page += 1
            print(Constant.shared.Finalresult.count)
            ImageModel.fatchimage()

        }
    }
}




