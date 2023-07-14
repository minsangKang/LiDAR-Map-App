//
//  ScanList.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/07/14.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

struct ScanList: View {
    @EnvironmentObject var listener: ScanInfoRowEventListener
    
    var body: some View {
        List {
            ForEach(ScanStorage.infos) { info in
                ScanInfoRow(info: info)
                    .onTapGesture {
                        listener.selectedLidarFileName = info.fileName
                    }
            }
        }
    }
}

struct ScanList_Previews: PreviewProvider {
    static var previews: some View {
        ScanList()
    }
}
