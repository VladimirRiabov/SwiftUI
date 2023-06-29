//
//  ProfileView.swift
//  M3Navigation
//
//  Created by Владимир on 29.06.23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        Button {
            print("Login")
        } label: {
            Text("Login")
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
