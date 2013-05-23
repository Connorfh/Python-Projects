from pylab import *
from scipy import *


#Complete Distance Tour Travels
def CompleteDist(c, R):
    dist=0
    for g in range(len(c)-1):
        dist += InitDist(R[c[g]],R[c[g+1]])
    dist += InitDist(R[c[-1]],R[c[0]])
    return dist

#Initial Distance Tour Travels
def InitDist(R1, R2):
    return sqrt((R1[0]-R2[0])**2+(R1[1]-R2[1])**2)

# Half of the segment will be reversed
# Reverasal Method: n[0]<->n[1], n[0]+1<->n[1]-1, n[0]+2<->n[1]-2,...
# The segment starts at the end and while moving towards the center swaps "c" cities  
def Rev(c, n):
    cn = len(c)
    nn = (1+ ((n[1]-n[0]) % cn))/2 
    for h in range(nn):
        i = (n[0]+h) % cn
        j = (n[1]-h) % cn
        (c[i],c[j]) = (c[j],c[i])  
    
def tran(c, n):
    cn = len(c)
    
    newc=[]
    # Range of Segment: n[0]...n[1]
    for h in range( (n[1]-n[0])%cn + 1):
        newc.append(c[ (h+n[0])%cn ])
    # Then n[5]...n[2]
    for h in range( (n[2]-n[5])%cn + 1):
        newc.append(c[ (h+n[5])%cn ])
    # Then n[3]...n[4]
    for h in range( (n[4]-n[3])%cn + 1):
        newc.append(c[ (h+n[3])%cn ])
    return newc

def Plot(c, R, dist):
    # Plot
    Pt = [R[c[g]] for g in range(len(c))]
    Pt += [R[c[0]]]
    Pt = array(Pt)
    title('Total distance='+str(dist))
    plot(Pt[:,0], Pt[:,1], '-o')
    show()

if __name__=='__main__':
#Define Parameters: Number of Cities, Distance Step, Start Distance, Travel Amount, Max Steps, Accepted Number of Steps and How often to Reverse
    nc = 20        
    stepX = 80    
    startX = 0.18       
    lessx = 0.9        
    maxSteps = 100*nc     
    maxAccepted = 10*nc   
    PRev = 0.5      

    # Randomly Choose City Coordinates
    R=[]  
    for g in range(nc):
        R.append( [rand(),rand()] )
    R = array(R)

    # Distance of Travel and the order that Cities are visited in
    c = range(nc)
    dist = CompleteDist(c, R)

    # Points of movement stored
    n = zeros(6, dtype=int)
    cn = len(R) 
    
    X = startX

    Plot(c, R, dist)
    
    for t in range(stepX):  

        accepted = 0
        for g in range(maxSteps): 
            # Choose two sufficiently close cities
            # Two cities n[0] and n[1] are choosen at random
            while True: 
                n[0] = int((cn)*rand())     
                n[1] = int((cn-1)*rand())   
                if (n[1] >= n[0]): n[1] += 1   
                if (n[1] < n[0]): (n[0],n[1]) = (n[1],n[0]) 
                nn = (n[0]+cn -n[1]-1) % cn  
                if nn>=3: break
        
            # Need to Index 1 before and 1 after the two cities
            # [n2,n0,n1,n3] Becomes the order
            n[2] = (n[0]-1) % cn
            n[3] = (n[1]+1) % cn  

           #Reverse the Segment 
            if PRev > rand(): 
                de = InitDist(R[c[n[2]]],R[c[n[1]]]) + InitDist(R[c[n[3]]],R[c[n[0]]]) - InitDist(R[c[n[2]]],R[c[n[0]]]) - 	InitDist(R[c[n[3]]],R[c[n[1]]])
                
                if de<0 or exp(-de/X)>rand(): 
                    accepted += 1
                    dist += de
                    Rev(c, n)
            #Segment Transposal
            else:
                nc = (n[1]+1+ int(rand()*(nn-1)))%cn 
                n[4] = nc
                n[5] = (nc+1) % cn
        
             
                de = -InitDist(R[c[n[1]]],R[c[n[3]]]) - InitDist(R[c[n[0]]],R[c[n[2]]]) - InitDist(R[c[n[4]]],R[c[n[5]]])
                de += InitDist(R[c[n[0]]],R[c[n[4]]]) + InitDist(R[c[n[1]]],R[c[n[5]]]) + InitDist(R[c[n[2]]],R[c[n[3]]])
                
                if de<0 or exp(-de/X)>rand(): 
                    accepted += 1
                    dist += de
                    c = tran(c, n)
                    
            if accepted > maxAccepted: break

        Plot(c, R, dist)
            
        print "X=%10.5f , distance= %10.5f , accepted steps= %d" %(X, dist, accepted)
        X *= lessx             
        if accepted == 0: break  

        
    Plot(c, R, dist)
