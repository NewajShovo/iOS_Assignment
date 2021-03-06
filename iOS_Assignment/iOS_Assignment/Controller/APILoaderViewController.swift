//
//  APILoaderViewController.swift
//  iOS_Assignment
//
//  Created by leo on 20/9/21.
//

import UIKit
let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.width
let RATIO:CGFloat = UIScreen.main.bounds.width/414.0
var API_PAGE_NO : Int = 1

class APILoaderViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoViewerCollectionView: UICollectionView!
    var presentAPIElement : APIElementList!
    var photoInfoStore : [Photos] = []
    var previousPage : Int = 0
    var fetchingMore = false
    override func viewDidLoad() {
        super.viewDidLoad()
        getImageFromRestAPI(pageNo:API_PAGE_NO) { elementList in
            self.presentAPIElement = elementList
            self.previousPage = elementList.current_page
            self.photoInfoStore.append(contentsOf: self.presentAPIElement.photos)
            DispatchQueue.main.async{
                self.setCollectionView();
                self.registerCustomCollectionViewCell();
                self.topView.backgroundColor = UIColor.white
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.activityIndicator.startAnimating();
    }
    
    func registerCustomCollectionViewCell(){
        photoViewerCollectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CustomCollectionViewCell");
        photoViewerCollectionView.register(UINib(nibName: "CustomSpinnerCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CustomSpinnerCell");
        photoViewerCollectionView.register(UINib(nibName: "ImageInsertionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ImageInsertionCollectionViewCell");
    }
    
    func setCollectionView(){
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        photoViewerCollectionView.collectionViewLayout = layout;
        photoViewerCollectionView.delegate = self;
        photoViewerCollectionView.dataSource = self;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            return self.photoInfoStore.count + (self.photoInfoStore.count/4);
        }
        else if (section == 1 && fetchingMore) {
            return 1
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        var indexValue = indexPath.row
        if ((indexValue + 1) % 5 == 0) || (indexPath.section == 1)  {
            let requiredHeight = 50 * RATIO
            return CGSize(width: Int(SCREEN_WIDTH), height: Int(requiredHeight));
        }
        else{
            let totalImageInsertionCell = indexValue/5
            indexValue = indexValue - totalImageInsertionCell
            let descriptionText = self.photoInfoStore[indexValue].description
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell;
            let cellWidth = cell.imageView.frame.size.width
            let cellInset = 12
            let width = (SCREEN_WIDTH - (CGFloat(cellInset * 3) + cellWidth)) * RATIO
            let height = 1000;
            let size = CGSize(width: Int(width), height: height);
            let font = UIFont.systemFont(ofSize: 12, weight: .regular)
            let attributes = [NSAttributedString.Key.font: font]
            let estimatedFrame = NSString(string: descriptionText).boundingRect(with: size, options:.usesLineFragmentOrigin , attributes: attributes, context: nil)
            let heightAboveDescriptionLabel = 41.0;
            let additionalHeightAfterText = 12.0
            let usualHeight = 104.0 * RATIO
            var requiredHeight = (CGFloat(estimatedFrame.size.height)+CGFloat(heightAboveDescriptionLabel)) < usualHeight ? Double(usualHeight)  : (Double(estimatedFrame.size.height)+heightAboveDescriptionLabel+additionalHeightAfterText)
            requiredHeight = requiredHeight * Double(RATIO)
            return CGSize(width: Int(SCREEN_WIDTH), height: Int(requiredHeight));
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var indexValue = indexPath.row
        if (indexPath.section==0){
            if (indexValue + 1) % 5 == 0  {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageInsertionCollectionViewCell", for: indexPath) as! ImageInsertionCollectionViewCell;
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell;
                let totalImageInsertionCount = indexPath.row/5
                indexValue = indexValue - totalImageInsertionCount
                let stringValue = self.photoInfoStore[indexValue].image_url[0];
                let urlString = URL(string: stringValue)
                cell.imageView.loadImage(from: urlString!)
                cell.titleLabel.text = self.photoInfoStore[indexValue].name;
                cell.voteCountLabel.text = numberFormat(from: self.photoInfoStore[indexValue].votes_count)
                cell.descriptionLabel.text = self.photoInfoStore[indexValue].description;
                return cell;
            }
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomSpinnerCell", for: indexPath) as! CustomSpinnerCell;
            cell.activityLoader.startAnimating()
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height{
            if !fetchingMore{
                let nextPage = self.presentAPIElement.current_page + 1
                API_PAGE_NO = nextPage
                fetchMoreDataFromAPI()
            }
        }
    }

    func fetchMoreDataFromAPI(){
        fetchingMore = true
        photoViewerCollectionView.reloadSections(IndexSet(integer: 1))
        getImageFromRestAPI(pageNo: API_PAGE_NO) { elementList in
            self.presentAPIElement = elementList
            if self.previousPage != self.presentAPIElement.current_page{
                self.photoInfoStore.append(contentsOf: self.presentAPIElement.photos)
                self.previousPage = self.presentAPIElement.current_page
            }
            DispatchQueue.main.async{
                self.fetchingMore = false
                self.photoViewerCollectionView.reloadData();
            }
        }
    }
}

