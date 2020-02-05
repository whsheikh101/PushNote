//
//  HowItWorksViewController.swift
//  PushNote
//
//  Created by Rizwan on 1/19/15.
//  Copyright (c) 2015 com. All rights reserved.
//

import UIKit

class HowItWorksViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var _collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblDesc: UILabel!
    
    let arrDesc: [String] = ["Notifications",
        "Open Pushnote Link",
        "Send Pushnote to friends",
        "Share a Pushnote on Social Media",
        "Explore the Pushnote Index",
        "Subscribe Pushnote Index",
        "Friends on Pushnote",
        "Push this to your friends",
        "Profile"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "How It Works"
         self.addBackBtn()
        let size: CGSize = self.view.frame.size
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize(width: size.width, height: size.height)
        self._collectionView = UICollectionView(frame: CGRect(x: 0, y: 120, width: size.width, height: size.height-250), collectionViewLayout: layout)
        layout.itemSize = CGSize(width:  self._collectionView.frame.size.width, height: self._collectionView.frame.size.height)
       //self._collectionView = UICollectionView(frame: CGRect(x: 0, y: 120, width: size.width, height: size.height-200), collectionViewLayout: layout)
        self._collectionView!.dataSource = self
        self._collectionView!.delegate = self
        self._collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        self._collectionView.isPagingEnabled = true
        self._collectionView!.backgroundColor = .clear
        self.view.addSubview(self._collectionView!)
       // print(self.pageControl)
       self.lblDesc.text = self.arrDesc[self.pageControl.currentPage]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.bringSubviewToFront(self.pageControl)
        self.view.bringSubviewToFront(self.lblDesc)
    }
    
    // MARK: UICollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrDesc.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) ;
        
        //let imageView: UIImageView = cell.viewWithTag(1000)? as UIImageView
        
        if let imgView: UIImageView = cell.viewWithTag(1000) as? UIImageView {
            
            setImagesAnimationToImage(imgView, index: indexPath.row)
        }
        else {
            print(cell.bounds)
            //cell.bounds.size.height =  cell.bounds.size.height-200
            let imageView: UIImageView = UIImageView(frame: cell.bounds)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.tag = 1000
            cell.addSubview(imageView)
            setImagesAnimationToImage(imageView, index: indexPath.row)
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("index \(index)")
    }

    func setImagesAnimationToImage(_ imageView:UIImageView, index:Int) {
        
        var images: [UIImage] = []
        switch index {
        
        case 0:
            images = [
                UIImage(named: "1-1.png")!,
             
            ]
            
            break
        case 1:
            images = [
                UIImage(named: "2-1.png")!,
             
            ]
            
            break
        case 2:
            images = [
                UIImage(named: "3-1.png")!,
           
            ]
            
            break
        case 3:
            images = [
                UIImage(named: "4-1.png")!,
              
            ]
            
            break
        case 4:
            images = [
                UIImage(named: "5-1.png")!,
              
               
            ]
            
            break
        case 5:
            images = [
             
                UIImage(named: "5-2.png")!,
                
            ]
            
            break
            
        case 6:
            images = [
                UIImage(named: "6-1.png")!,
               
            ]
            
            break
        case 7:
            images = [
                UIImage(named: "7-1.png")!,
                
            ]
            
            break
        case 8:
            images = [
                UIImage(named: "8-1.png")!,
                
            ]
            
            break
        default:
            images = [
                UIImage(named: "1-1.png")!,
               
            ]
            break
        
        }
        
        imageView.image = images[0]
        imageView.animationImages = images
        imageView.animationDuration = TimeInterval(images.count)
        imageView.animationRepeatCount = 5
        imageView.startAnimating()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let point: CGPoint = self._collectionView.contentOffset
        let index = Int(point.x/self.view.frame.size.width)
        self.pageControl.currentPage = index
        
        self.lblDesc.text = self.arrDesc[index]
    }
    
    @IBAction func pageControlValueChanged(_ sender: AnyObject) {
        
        self._collectionView.scrollToItem(at: IndexPath(item: self.pageControl.currentPage, section: 0), at: UICollectionView.ScrollPosition(), animated: true)
        //println(self.pageControl.currentPage)
    }
}
